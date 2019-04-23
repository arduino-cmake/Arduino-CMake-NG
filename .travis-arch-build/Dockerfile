FROM archlinux/base
RUN pacman --noconfirm -Sy
RUN pacman --noconfirm -S arduino arduino-avr-core git cmake make lsb-release
RUN mkdir -p /root/Arduino/libraries
RUN git clone https://github.com/arduino-libraries/Servo.git /root/Arduino/libraries/Servo
RUN git clone https://github.com/arduino-libraries/Stepper.git /root/Arduino/libraries/Stepper
RUN git clone https://github.com/arduino-libraries/Ethernet.git /root/Arduino/libraries/Ethernet
COPY run.sh /run.sh
CMD /run.sh

