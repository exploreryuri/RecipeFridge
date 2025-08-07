"""Recipe routes."""
from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from .. import models, schemas
from ..database import get_db
from .user import get_current_user

router = APIRouter()


@router.get("/recipes", response_model=List[schemas.Recipe])
def list_recipes(current_user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    return db.query(models.Recipe).all()


@router.post("/recipes", response_model=schemas.Recipe)
def add_recipe(recipe: schemas.RecipeCreate, current_user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    db_recipe = models.Recipe(name=recipe.name, description=recipe.description)
    db.add(db_recipe)
    db.commit()
    db.refresh(db_recipe)
    for ing in recipe.ingredients:
        db_ing = models.RecipeIngredient(recipe_id=db_recipe.id, product_name=ing.product_name, quantity=ing.quantity)
        db.add(db_ing)
    db.commit()
    db.refresh(db_recipe)
    return db_recipe
