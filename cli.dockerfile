FROM amazon/aws-cli 
RUN ls /bin
RUN yum install python37 -y
RUN python3 --version
RUN pip-3 install aws-sam-cli

ENTRYPOINT ["/bin/bash"]
