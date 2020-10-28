################## BASE IMAGE ######################

FROM biocontainers/biocontainers:v1.1.0_cv2

# set the environment variables
ENV star_version 2.7.0e

# run update and install necessary tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    vim \
    less \
    curl \
    libnss-sss \
    zlib1g-dev

# download and install star
WORKDIR /usr/local/bin/
RUN curl -SL https://github.com/alexdobin/STAR/archive/${star_version}.tar.gz \
    | tar -zxvC /usr/local/bin/
WORKDIR /usr/local/bin/STAR-${star_version}/source/
RUN make STAR
RUN ln -s /usr/local/bin/STAR-${star_version}/bin/Linux_x86_64/STAR /usr/local/bin/STAR
RUN ln -s /usr/local/bin/STAR-${star_version}/bin/Linux_x86_64/STARlong /usr/local/bin/STARlong
WORKDIR /usr/local/bin/

COPY star_wrapper.sh /bin
RUN chmod +x /bin/star_wrapper.sh

ENTRYPOINT ["/bin/star_wrapper.sh"]