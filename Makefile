VERSION_FILE=.version
VERSION_STRING=$(shell cat "$(VERSION_FILE)")

.PHONY: docs get-version set-version git-tag pod-publish publish

docs:
	@jazzy

get-version:
	@echo $(VERSION_STRING)

set-version:
	$(eval NEW_VERSION := $(filter-out $@,$(MAKECMDGOALS)))
	@echo "$(NEW_VERSION)" > "$(VERSION_FILE)"
	@sed -i '' '/^[[:blank:]]*s.version/ s/'\"'[^'\"'][^'\"']*'\"'/'\"'$(NEW_VERSION)'\"'/' SheetPresentation.podspec
	@sed -i '' '/^[[:blank:]]*MARKETING_VERSION/ s/= [^;]*;/= $(NEW_VERSION);/' SheetPresentation.xcodeproj/project.pbxproj
	@sed -i '' '1s/^/\# '$(NEW_VERSION)'\n\n/' CHANGELOG.md

git-tag:
ifneq ($(strip $(shell git status --untracked-files=no --porcelain 2>/dev/null)),)
	$(error git state is not clean)
endif
	git tag -a "$(VERSION_STRING)" -m "$(VERSION_STRING)"
	git push origin "$(VERSION_STRING)"

pod-publish:
	pod trunk push SheetPresentation.podspec

publish: pod-publish

%:
	@:
