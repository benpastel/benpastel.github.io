.PHONY: run-local
run-local:
	docker run --rm \
	  --volume="$$PWD:/srv/jekyll:Z" \
	  --publish 4000:4000 \
	  jekyll/jekyll:4.2.0 \
	  jekyll serve --verbose