FROM fedora:latest
RUN dnf install -y arduino cmake make redhat-lsb-core git
RUN mkdir -p /root/.arduino15 /root/Arduino/libraries
RUN git clone https://github.com/arduino-libraries/Servo.git /root/Arduino/libraries/Servo
RUN git clone https://github.com/arduino-libraries/Stepper.git /root/Arduino/libraries/Stepper
RUN git clone https://github.com/arduino-libraries/Ethernet.git /root/Arduino/libraries/Ethernet
COPY preferences.txt /root/.arduino15/preferences.txt
COPY run.sh /run.sh
CMD /run.sh