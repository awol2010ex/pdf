FROM python:3-alpine

ENV APP_HOME /app
WORKDIR $APP_HOME
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add libreoffice \
	build-base \ 
	# Install fonts
	msttcorefonts-installer fontconfig && \
    update-ms-fonts && \
    fc-cache -f

RUN apk add --no-cache build-base libffi libffi-dev
RUN apk add --update ttf-dejavu
RUN pip install Flask requests gevent
COPY . $APP_HOME

# prevent libreoffice from querying ::1 (ipv6 ::1 is rejected until istio 1.1)
RUN mkdir -p /etc/cups && echo "ServerName 127.0.0.1" > /etc/cups/client.conf


RUN cp /app/SimSun.ttf /usr/share/fonts/
RUN chmod 644 /usr/share/fonts/SimSun.ttf
RUN fc-cache –fv

CMD ["python", "to-pdf.py"]
