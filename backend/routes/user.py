"""User routes and dependencies."""
from fastapi import APIRouter, Depends, Header, HTTPException
from sqlalchemy.orm import Session

from .. import models, schemas
from ..auth import verify_token
from ..database import get_db

router = APIRouter()


def get_current_user(db: Session = Depends(get_db), authorization: str = Header(...)):
    """Retrieve or create a user based on Firebase id token."""
    id_token = authorization.replace("Bearer ", "")
    firebase_uid = verify_token(id_token)
    user = db.query(models.User).filter(models.User.firebase_uid == firebase_uid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@router.post("/register", response_model=schemas.User)
def register(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = models.User(email=user.email, firebase_uid=user.firebase_uid)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
