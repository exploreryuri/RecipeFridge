"""Pydantic schemas for the API."""
from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel


class ProductBase(BaseModel):
    name: str
    quantity: int = 1
    expires_at: Optional[datetime] = None


class ProductCreate(ProductBase):
    pass


class Product(ProductBase):
    id: int

    class Config:
        orm_mode = True


class UserBase(BaseModel):
    email: str


class UserCreate(UserBase):
    firebase_uid: str


class User(UserBase):
    id: int
    products: List[Product] = []

    class Config:
        orm_mode = True


class RecipeIngredient(BaseModel):
    product_name: str
    quantity: str


class RecipeBase(BaseModel):
    name: str
    description: Optional[str] = None
    ingredients: List[RecipeIngredient] = []

      
class RecipeCreate(RecipeBase):
    pass


class Recipe(RecipeBase):
    id: int

    class Config:
        orm_mode = True
