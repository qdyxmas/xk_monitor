FROM markadams/chromium-xvfb-py3

# Add requirements.txt
ADD requirements.txt /tmp/

ARG pip_mirror=http://mirrors.aliyun.com/pypi/simple
ARG pip_host=mirrors.aliyun.com

# Upgrade pip3
# Install app requirements
RUN pip3 install --upgrade pip -i ${pip_mirror} --trusted-host ${pip_host} --no-cache-dir
RUN pip3 install -r /tmp/requirements.txt -i ${pip_mirror} --trusted-host ${pip_host} --no-cache-dir

ARG root_dir=xk_k8stest
# Create app directory
ADD . /${root_dir}
# Set the default directory for our environment
ENV HOME /${root_dir}
WORKDIR /${root_dir}

EXPOSE 10086


ENTRYPOINT ["bash", "/xk_k8stest/start_service.sh"]
