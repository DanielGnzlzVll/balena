FROM resin/raspberrypi3-debian:stretch

RUN apt-get update && apt-get install -yq \
    unzip coreutils curl python3 \
    libprotobuf-dev libleveldb-dev \
    libsnappy-dev libopencv-dev libhdf5-serial-dev \
    protobuf-compiler libatlas-base-dev \
    python3-dev python-dev python3-numpy automake cmake \
    make byacc lsb-release  \
    libgflags-dev libgoogle-glog-dev liblmdb-dev \
    swig3.0 libxslt-dev libxml2-dev gfortran \
    python3-yaml python3-nose python3-tk \
    tar wget python3-pip \
    python3-h5py python3-lxml python3-matplotlib python3-gi \
    python3-protobuf python3-dateutil  python3-six \
    libatlas-base-dev libqt4-test libjasper-dev libqtgui4 python3-pyqt5 gstreamer-1.0 libgtk-3-dev \
    python3-setuptools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV INITSYSTEM on

RUN apt-get update && apt-get install -y \
		dbus fbi \
		dnsmasq \
		hostapd \
		rfkill \
        zip \
        wireless-tools \
	&& rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip
COPY pip.conf /etc/pip.conf
COPY pip.conf /etc/pip3.conf
RUN pip3 install  --retries 10 -U  Cython
RUN pip3 install --upgrade --retries 10 setuptools wheel

COPY requirements.txt requirements.txt
RUN READTHEDOCS=True pip3 install --upgrade --upgrade-strategy eager --retries 10 -r requirements.txt

ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
RUN apt-get update && apt-get install -y network-manager && systemctl mask NetworkManager.service
