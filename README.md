# MyMemo with Flutter-Fire

## Limitations

- Not able to sign in at windows desktop
- `.env` must be renamed as `env` to prevent deployment error

## Deployment to Firebase hosting

```
flutter build web --release
firebase deploy --only=hosting
```

## Todos

- change domain
- github workflow
- support for backticks
- shortcut
- upload images
- find memos
- constraints
- search in app bar, sliver app bar
  - https://www.youtube.com/watch?v=TlbbIQykHK0
- prevent double loading when scrolling more items
