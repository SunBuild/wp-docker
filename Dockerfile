FROM appsvcorg/alpine-php-mysql:0.1 
MAINTAINER Azure App Service Container Images <appsvc-images@microsoft.com>

#
ENV DOCKER_BUILD_HOME "/dockerbuild"

# ====================
# Download and Install
# ~. tools
# 1. redis
# 2. wordpress
# ====================

WORKDIR $DOCKER_BUILD_HOME
RUN set -ex \
	# --------
	# 1. redis
	# --------
        && apk add --update git \
        # cp in final
	# ----------
	# ~. clean up
	# ----------
	&& rm -rf /var/cache/apk/* 


RUN apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd

# =========
# Configure
# =========
# httpd confs
COPY httpd-wordpress.conf $HTTPD_CONF_DIR/

ENV GIT_REPO=https://github.com/WordPress/WordPress.git 

COPY wp-config.php wprun.sh /var/wwww
COPY sshd_config /etc/ssh/


COPY wprun.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wprun.sh
EXPOSE 2222 80
ENTRYPOINT ["wprun.sh"]
