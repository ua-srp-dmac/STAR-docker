################## BASE IMAGE ######################

FROM biocontainers/biocontainers:v1.1.0_cv2

# set the environment variables
ENV star_version 2.7.0e

USER 0
# run update and install necessary tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    vim \
    less \
    curl \
    libnss-sss \
    zlib1g-dev

# download and install star
ADD https://github.com/alexdobin/STAR/archive/${star_version}.tar.gz /usr/bin/
RUN tar -xzf /usr/bin/${star_version}.tar.gz -C /usr/bin/
RUN cp /usr/bin/STAR-${star_version}/bin/Linux_x86_64/* /usr/local/bin

COPY star_wrapper.sh /bin
RUN chmod +x /bin/star_wrapper.sh

ENTRYPOINT ["/bin/star_wrapper.sh"]