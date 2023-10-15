source = src
output = dist
bin = bin

md_files := $(shell find $(source) -name "*.md")
html_files := $(patsubst $(source)/%.md,$(output)/%.html,$(md_files))

thumb := $(bin)/thumb
rss := $(bin)/rss
sitemap := $(bin)/sitemap

pandoc_releases := https://github.com/jgm/pandoc/releases/download
pandoc_version := 3.1.6.2
pandoc := pandoc-$(pandoc_version)
pandoc_linux := $(pandoc)-linux-amd64.tar.gz

# check if pandoc directory already exists, then add it to PATH (for vercel deployment)
ifneq ("$(wildcard ${pandoc})","")
	export PATH := ${PATH}:${PWD}/${pandoc}/bin
endif

install: html static dist/sitemap.xml dist/rss.xml

vercel:
	@yum install wget
	@wget $(pandoc_releases)/$(pandoc_version)/$(pandoc_linux)
	@tar -xvf $(pandoc_linux)
	@yarn install

dev:
	find src templates public templates filters -type f | entr make

html: $(html_files)

dist/rss.xml: $(md_files) $(rss)
	@$(rss)

dist/sitemap.xml: $(md_files) $(sitemap)
	@$(sitemap)

dist/%.html: src/%.md templates/* public/styles.css
	@mkdir -p $(@D)
	@pandoc -d pandoc.yml $< -o $@
	@echo "[html generated]:" $@

static: public/*
	cd $(source) && find . -type f ! -name "*.md" -print0 | cpio -pdvm0 ../$(output)
	cp -r public/* $(output)

clean: 
	@rm -vrf $(output)


.PHONY: all html static clean dev vercel
