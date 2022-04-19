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
