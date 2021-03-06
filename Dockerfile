FROM centos:7
MAINTAINER Ansible Playbook Bundle Community

RUN curl https://copr.fedorainfracloud.org/coprs/g/ansible-service-broker/ansible-service-broker-latest/repo/epel-7/group_ansible-service-broker-ansible-service-broker-latest-epel-7.repo -o /etc/yum.repos.d/asb.repo
RUN yum -y install epel-release centos-release-openshift-origin \
    && yum -y install --setopt=tsflags=nodocs origin-clients python-openshift \
       python-pip apb-base-scripts \
    && yum clean all

RUN pip install -U apb requests

ENV BASE_DIR=/opt/apb
ENV HOME=${BASE_DIR}

RUN mkdir -p /opt/apb/.kube

COPY config /opt/apb/.kube/config
COPY create-patch.py /opt/apb/create-patch.py
RUN chmod -R g=u /opt/apb

COPY entrypoint.sh /usr/bin/

ENTRYPOINT ["entrypoint.sh"]
