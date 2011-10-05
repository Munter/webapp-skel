# Put all 'bin' dirs beneath node_modules into $PATH so that we're using
# the locally installed AssetGraph:
# Ugly 'subst' hack: Check the Make Manual section 8.1 - Function Call Syntax
NPM_BINS := $(subst bin node,bin:node,$(shell if test -d node_modules; then find node_modules/ -name bin -type d; fi))
ifneq ($(NPM_BINS),)
	PATH := ${NPM_BINS}:${PATH}
endif

PAGES = http-pub/index.html
CDN_ROOT = http://cdn.mydomain.com/static/
TARGET_LOCALES=en_US
LABELS = \
	--label Ext:extJs4Dir=http-pub/3rdparty/ExtJS/src \
	--label extsdk=http-pub/3rdparty/ExtJS/build/sdk.jsb3

default: production
.PHONY: development clean
development: ${PAGES}
production: http-pub-production
cdn: http-pub-cdn

http-pub/%.html: http-pub/%.html.template $(shell find http-pub -name '*.js' -o -name '*.css')
	buildDevelopment \
		--cssimports \
		--root=http-pub \
		${LABELS} \
		$<

http-pub-production: ${PAGES}
	-rm -fr $@
	buildProduction \
		--cssimports \
		--root http-pub \
		--outroot $@ \
		--locale ${TARGET_LOCALES} \
		${LABELS} \
		${PAGES}

http-pub-cdn: http-pub-production
	-rm -fr $@
	prepareForCDN \
		--root $< \
		--outroot $@ \
		--cdnroot ${CDN_ROOT} \
		$</*.html

clean:
	-rm -f http-pub/index.html
	-rm -fr http-pub-production
	-rm -fr http-pub-cdn
	-rm -fr doc doc-html
