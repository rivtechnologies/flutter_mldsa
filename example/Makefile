CHROMEDRIVER?=chromedriver

.PHONY: build-web
build-web:
	@cd .. && flutter_rust_bridge_codegen build-web --release
	@rm -rf web/pkg
	@cp -r ../web/pkg web/pkg
	@flutter build web

.PHONY: run-web
run-web:
	@$(MAKE) build-web 
	@flutter run --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp -d chrome

.PHONY: test-web
test-web:
	@$(MAKE) build-web
	@( \
		$(CHROMEDRIVER) --port=4444 & \
		CHROME_PID=$$!; \
		trap "kill $$CHROME_PID" EXIT; \
		sleep 2; \
		flutter drive --driver=test_driver/integration_test.dart -d chrome --target=integration_test/master_integration_test_web.dart --wasm \
	)
