# Ububtu based
FROM phusion/baseimage:0.9.16
MAINTAINER Joeri van Dooren <ure@mororless.be>

# install basic stuff
RUN apt-get update && apt-get install -y \
    libmysqlclient-dev mysql-client \
    python-dev python-pip \
    wget jq build-essential \
    libcurl4-openssl-dev

# install useful python packages
RUN pip install --upgrade pip
RUN pip install memsql ipython psutil

# configure locale
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

# configure environment
RUN echo en_US.UTF-8 > /etc/container_environment/LANG
RUN echo en_US.UTF-8 > /etc/container_environment/LC_ALL
RUN echo en_US:en > /etc/container_environment/LANGUAGE
RUN echo docker-quickstart > /etc/container_environment/MEMSQL_OPS_USER_AGENT_SUFFIX
RUN chmod 755 /etc/container_environment
RUN chmod 644 /etc/container_environment.sh

# set UTC
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# download and install MemSQL Ops
# then reduce size by symlinking objdir and lib from one install to the other
ADD setup_ops.sh /tmp/setup_ops.sh
RUN /tmp/setup_ops.sh

# add helper scripts
ADD memsql-shell /usr/local/bin/memsql-shell
ADD check-system /usr/local/bin/check-system
ADD simple-benchmark /usr/local/bin/simple-benchmark

# add start scripts
ADD scripts/run.sh /scripts/run.sh

# expose ports
EXPOSE 3306
EXPOSE 3307
EXPOSE 9000
EXPOSE 9022
EXPOSE 8443

# Clean up APT
RUN apt-get clean &&  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Openshiftify
RUN chmod -R a+rw /root && chmod a+rwx /scripts/run.sh && chmod -R a+rw /etc/ssh && chmod -R a+rwx /memsql && chmod a+rw /etc/passwd

WORKDIR /memsql

ENTRYPOINT ["/scripts/run.sh"]

# Set labels used in OpenShift to describe the builder images
LABEL io.k8s.description="Debian linux based MemSQL" \
      io.k8s.display-name="alpine memsql" \
      io.openshift.tags="builder,sql,memsql" \
      io.openshift.min-memory="1Gi" \
      io.openshift.min-cpu="1" \
      io.openshift.non-scalable="false"
