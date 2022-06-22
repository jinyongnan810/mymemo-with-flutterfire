# MyMemo with Flutter-Fire

## Limitations

- Not able to sign in at windows desktop
- `.env` must be renamed as `env` to prevent deployment error
- backticks create a blocked code
- firebase firestore doesn't support search by string contains
- cannot go to search target with ctrl+f

## run with specific port

- flutter run -d chrome --web-port=1234

## Deployment to Firebase hosting

```
firebase deploy --only firestore:rules
firebase deploy --only storage:rules

flutter build web --release
firebase deploy --only=hosting

```

## deploy cors policy to storage

- gsutil cors set cors.json gs://mymemo-98f76.appspot.com

## Todos

- link, img header style
- github workflow
- support for backticks
- upload images by paste
- find memos
- search in app bar, sliver app bar
  - https://www.youtube.com/watch?v=TlbbIQykHK0
- fix scroll in mobile devices
- make a vertical version of the split widget
