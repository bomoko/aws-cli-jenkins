FROM amazon/aws-cli 
RUN yum install python37 -y
RUN python3 --version
RUN pip-3 install aws-sam-cli
COPY . /app
ENTRYPOINT ["/bin/bash"]
