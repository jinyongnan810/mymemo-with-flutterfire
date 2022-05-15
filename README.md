# MyMemo with Flutter-Fire

## Limitations

- Not able to sign in at windows desktop
- `.env` must be renamed as `env` to prevent deployment error
- backticks create a blocked code

## Deployment to Firebase hosting

```
flutter build web --release
firebase deploy --only=hosting

```

## Todos

- link, img header style
- github workflow
- support for backticks
- upload images
- find memos
- search in app bar, sliver app bar
  - https://www.youtube.com/watch?v=TlbbIQykHK0
- fix scroll in mobile devices
- make a vertical version of the split widget
