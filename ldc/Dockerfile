FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
  p7zip-full \
  curl \
  build-essential \
  git \
  libxml2 \
  ninja-build \
  cmake \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m ldc \
  && mkdir /home/ldc/work && chown ldc /home/ldc/work \
  && su -l -c "git clone https://github.com/raspberrypi/tools.git" - ldc

RUN sed -i 's/CipherString = DEFAULT@SECLEVEL=2/#CipherString = DEFAULT@SECLEVEL=2/g' /etc/ssl/openssl.cnf \
  && curl -L https://downloads.raspberrypi.org/raspbian_lite_latest -o /tmp/raspbian.zip \
  && sed -i 's/#CipherString = DEFAULT@SECLEVEL=2/CipherString = DEFAULT@SECLEVEL=2/g' /etc/ssl/openssl.cnf \
  && 7z e -so /tmp/raspbian.zip '*.img' > /tmp/raspbian.img \
  && rm /tmp/raspbian.zip \
  && 7z e -spf -o/tmp /tmp/raspbian.img 1.img \
  && rm /tmp/raspbian.img \
  && mkdir /home/ldc/sysroot \
  && 7z e -spf -o/home/ldc/sysroot /tmp/1.img lib/ usr/include/ usr/lib/ opt/vc/ \
  && chown -R ldc:ldc /home/ldc/sysroot \
  && rm /tmp/1.img

RUN su -l -c "curl -fsS https://dlang.org/install.sh | bash -s ldc" - ldc \
  && echo "source ~/dlang/ldc-*/activate" >> /home/ldc/.bashrc
COPY build_runtime.sh /home/ldc/build_runtime.sh

USER ldc
WORKDIR /home/ldc
CMD ["/bin/bash"]

