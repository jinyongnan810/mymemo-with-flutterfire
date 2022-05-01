# MyMemo with Flutter-Fire

## Firestore rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /memos/{memo} {
      allow read: if true;
      allow update, delete: if
      		request.auth != null && request.auth.uid == resource.data.userId;
      allow create: if
      		request.auth != null
    }
  }
}
```

## Limitations

- Not able to sign in at windows desktop
- `.env` must be renamed as `env` to prevent deployment error

## Deployment to Firebase hosting

- `firebase deploy`

## Todos

- change domain
- github workflow
- support for backticks
- get email&profile from userId
- shortcut
- upload images
- find memos
- constraints
- search in app bar, sliver app bar
  - https://www.youtube.com/watch?v=TlbbIQykHK0
