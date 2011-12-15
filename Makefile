DEV_JS_CSS_I18N_SOURCES = $(shell find ./http-pub -name "*.js" -o -name "*.css" -o -name "*.i18n")

# Put all 'bin' dirs beneath node_modules into $PATH so that we're using
# the locally installed AssetGraph:
# Ugly 'subst' hack: Check the Make Manual section 8.1 - Function Call Syntax
NPM_BINS := $(subst bin node,bin:node,$(shell if test -d node_modules; then find node_modules/ -name bin -type d; fi))
ifneq ($(NPM_BINS),)
	PATH := ${NPM_BINS}:${PATH}
endif

DEVELOPMENT_TARGETS = http-pub/index.html
CDNROOT ?= http://cdn.mydomain.com/
TARGET_LOCALES ?= en_US
LABELS = \
#	--label Ext:extJs4Dir=http-pub/3rdparty/ExtJS/src \
#	--label extsdk=http-pub/3rdparty/ExtJS/build/sdk.jsb3

default: production
.PHONY: development clean
development: ${DEVELOPMENT_TARGET}
production: http-pub-production
cdn: http-pub-production-cdn

http-pub/%.html: http-pub/%.html.template ${DEV_JS_CSS_I18N_SOURCES}
	buildDevelopment \
		--livecss \
		--cssimports \
		--root=http-pub \
		--version `git describe --long --tags --always 2>/dev/null || echo unknown` \
		${LABELS} \
		$<

http-pub-production: ${DEVELOPMENT_TARGETS}
	-rm -fr $@
	buildProduction \
		--root http-pub \
		--outroot $@ \
		--locale ${TARGET_LOCALES} \
		${LABELS} \
		${DEVELOPMENT_TARGETS}

#
# CDN-enabled production version where ${CDNROOT} should be proxied to the /static/cdn dir:
#
http-pub-production-cdn: ${DEVELOPMENT_TARGETS}
	-rm -fr $@
	buildProduction \
		--root http-pub \
		--outroot $@ \
		--cdnroot ${CDNROOT} \
		--cdnoutroot $@/static/cdn \
		--locale ${TARGET_LOCALES} \
		${LABELS} \
		${DEVELOPMENT_TARGETS}

clean:
	-rm -f http-pub/index.html
	-rm -fr http-pub-production http-pub-production-cdn doc doc-html
