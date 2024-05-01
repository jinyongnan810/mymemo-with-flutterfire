publish:
	flutter build web --release && firebase deploy --only=hosting