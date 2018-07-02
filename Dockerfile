FROM debian:stretch-slim

RUN apt-get update \
&& apt-get install -y wget \
libmariadbclient-dev \
libpq-dev \
libexpat-dev \
libodbc1 \
jq \
procps \
mariadb-client-10.1 \
&& wget https://github.com/manticoresoftware/manticore/releases/download/2.7.0/manticore_2.7.0-180611-3d60c8e-release-stemmer.stretch_amd64-bin.deb \
&& dpkg -i manticore_2.7.0-180611-3d60c8e-release-stemmer.stretch_amd64-bin.deb \
&& mkdir -p /var/lib/manticore/data /var/lib/manticore/log \
&& touch /var/lib/manticore/log/searchd.log /var/lib/manticore/log/query.log

COPY sphinx.conf /etc/sphinxsearch/sphinx.conf

VOLUME /var/lib/manticore /etc/sphinxsearch
EXPOSE 9306
EXPOSE 9312

CMD ["searchd", "--nodetach"]