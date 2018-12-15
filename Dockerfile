# どのイメージを基にするか
FROM continuumio/anaconda3:5.2.0
RUN echo "now building..."

# =================================================== #
# awscli
# =================================================== #
#RUN pip install awscli
RUN pip install awscli && \
    pip install --upgrade awscli && \
    pip install wheel && \
    pip install pyyaml

ENV TZ=Asia/Tokyo

RUN mkdir /tmp/dump \
           /tmp/input \
           /tmp/output \
           /tmp/picture \
           /tmp/log

# Copy script files
COPY kicker.sh /tmp/
COPY *.py /tmp/
COPY conf/ /tmp/conf/

# run scripts
CMD echo "now running..."
WORKDIR /tmp
CMD /bin/bash /tmp/kicker.sh

