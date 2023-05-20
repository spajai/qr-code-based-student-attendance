FROM perl:latest

ENV CATALYST_PORT 3000
ENV WORKDIR /usr/app/qrattendance
ENV PERL5LIB /usr/app/qrattendance/lib

WORKDIR ${WORKDIR}

RUN wget --quiet -O /usr/bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    &&  chmod 755 /usr/bin/wait-for-it
## installs tools, libraries and bootstraps Perl CPAN packages
RUN apt-get -qq update -y \
    &&  apt-get install -y --no-install-recommends build-essential make gcc  libdbd-pg-perl  libtool  libevent-dev  patch \
    &&  rm -rf /var/lib/{apt,dpkg,cache,log}/ /usr/share/doc/

RUN wget --quiet -O /usr/bin/cpm https://git.io/cpm \
    &&  chmod 755 /usr/bin/cpm

RUN cpm install --no-show-progress --workers=10 --retry --global Module::Install CPAN::Meta::Prereqs Carton::Snapshot Text::CSV List::MoreUtils Catalyst::View::TT Plack::Handler::Starman\
    &&  rm -rf ~/.perl-cpm

## minimum we need to install CPAN packages deps, so that we can cache them
COPY cpanfile cpanfile.snapshot ${WORKDIR}/

## cleans up apt cache & log files
RUN cpm install --with-develop --no-show-progress --workers=10 --retry --global \
    &&  rm -rf ~/.perl-cpm \
    &&  find /usr -name '*.pod' -delete

## copies app files as the last step so that every step above is cached
COPY . ${WORKDIR}

RUN ["prove", "-rv", "t/"]

EXPOSE ${CATALYST_PORT}

ENTRYPOINT ["/usr/app/qrattendance/entry.sh"]
