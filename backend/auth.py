"""Firebase authentication utilities."""
import firebase_admin
from firebase_admin import auth, credentials
from fastapi import HTTPException, status

# Initialize Firebase SDK lazily
_app = None

def init_firebase():
    global _app
    if not _app:
        cred = credentials.Certificate({
            "type": "service_account",
            "project_id": "your-project-id",
            "private_key_id": "dummy",
            "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
            "client_email": "foo@bar",
            "client_id": "123",
            "token_uri": "https://oauth2.googleapis.com/token",
        })
        _app = firebase_admin.initialize_app(cred)


def verify_token(id_token: str) -> str:
    """Return the Firebase UID associated with the given id token."""
    init_firebase()
    try:
        decoded_token = auth.verify_id_token(id_token)
        return decoded_token["uid"]
    except Exception as exc:  # pragma: no cover - network failures etc.
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=str(exc))
