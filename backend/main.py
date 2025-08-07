"""FastAPI application for RecipeFridge."""
from fastapi import FastAPI

from .database import Base, engine
from .routes import user, product, recipe

Base.metadata.create_all(bind=engine)

app = FastAPI(title="RecipeFridge API")

app.include_router(user.router, prefix="/users", tags=["users"])
app.include_router(product.router, tags=["products"])
app.include_router(recipe.router, tags=["recipes"])
