# RecipeFridge

Prototype project containing a FastAPI backend with PostgreSQL models and a Flutter
mobile application using BLoC. The server authenticates users via Firebase and
tracks fridge products, recipes and expiration notifications.

## Backend

Run the API locally with:

```bash
uvicorn backend.main:app --reload
```

## Mobile

The Flutter code in `mobile/` demonstrates a simple BLoC based client that
interacts with the backend and shows products with expiration dates.
