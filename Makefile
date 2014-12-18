DOCKER_NAMESPACE =	armbuild/
NAME =			ocs-distrib-archlinux
VERSION =		2014-12-02
VERSION_ALIASES =	latest
TITLE =			Archlinux
DESCRIPTION =		Archlinux latest
SOURCE_URL =		https://github.com/online-labs/image-archlinux


## Image tools  (https://github.com/online-labs/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/image-tools | bash
-include docker-rules.mk
## Below you can add custom makefile commands and overrides
