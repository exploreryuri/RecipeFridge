"""FastAPI application for RecipeFridge."""
from datetime import datetime, timedelta
from typing import List

from fastapi import Depends, FastAPI, Header, HTTPException
from sqlalchemy.orm import Session

from . import models, schemas
from .database import Base, engine, get_db
from .auth import verify_token

Base.metadata.create_all(bind=engine)

app = FastAPI(title="RecipeFridge API")


def get_current_user(db: Session = Depends(get_db), authorization: str = Header(...)):
    """Retrieve or create a user based on Firebase id token."""
    id_token = authorization.replace("Bearer ", "")
    firebase_uid = verify_token(id_token)
    user = db.query(models.User).filter(models.User.firebase_uid == firebase_uid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@app.post("/users/register", response_model=schemas.User)
def register(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = models.User(email=user.email, firebase_uid=user.firebase_uid)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


@app.get("/products", response_model=List[schemas.Product])
def list_products(current_user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    return db.query(models.Product).filter(models.Product.owner_id == current_user.id).all()


@app.post("/products", response_model=schemas.Product)
def add_product(product: schemas.ProductCreate, current_user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    db_product = models.Product(**product.dict(), owner_id=current_user.id)
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    return db_product


@app.put("/products/{product_id}", response_model=schemas.Product)
def update_product(product_id: int, product: schemas.ProductCreate, current_user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    db_product = db.query(models.Product).filter(models.Product.id == product_id, models.Product.owner_id == current_user.id).first()
    if not db_product:
        raise HTTPException(status_code=404, detail="Product not found")
    for field, value in product.dict().items():
        setattr(db_product, field, value)
    db.commit()
    db.refresh(db_product)
    return db_product


@app.delete("/products/{product_id}")
def delete_product(product_id: int, current_user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    db_product = db.query(models.Product).filter(models.Product.id == product_id, models.Product.owner_id == current_user.id).first()
    if not db_product:
        raise HTTPException(status_code=404, detail="Product not found")
    db.delete(db_product)
    db.commit()
    return {"status": "deleted"}


@app.get("/notifications")
def expiring_products(current_user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    threshold = datetime.utcnow() + timedelta(days=1)
    products = db.query(models.Product).filter(models.Product.owner_id == current_user.id, models.Product.expires_at <= threshold).all()
    return [schemas.Product.from_orm(p) for p in products]
