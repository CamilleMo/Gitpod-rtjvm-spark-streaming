FROM gitpod/workspace-full:latest
USER gitpod
RUN sudo apt-get update && sudo apt-get install -y zsh && \
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh && \
    rm -rf install.sh

RUN sudo sh -c '(echo "#!/usr/bin/env sh" && curl -L https://github.com/lihaoyi/Ammonite/releases/download/2.0.4/2.13-2.0.4) > /usr/local/bin/amm && chmod +x /usr/local/bin/amm'
RUN curl -fLo coursier https://git.io/coursier-cli && chmod +x coursier && sudo mv coursier /usr/local/bin/
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list && \
	echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list && \
	curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add && \
	sudo apt-get update && \
	sudo apt-get install sbt
RUN brew install scala scalaenv
RUN sudo env "PATH=$PATH" coursier bootstrap org.scalameta:scalafmt-cli_2.12:2.4.2 \
  -r sonatype:snapshots \
  -o /usr/local/bin/scalafmt --standalone --main org.scalafmt.cli.Cli
RUN scalaenv install scala-2.9.3 && scalaenv global scala-2.9.3
RUN bash -cl "set -eux \
    version=0.8.0 \
    coursier fetch \
        org.scalameta:metals_2.12:$version \
        org.scalameta:mtags_2.13.1:$version \
        org.scalameta:mtags_2.13.0:$version \
        org.scalameta:mtags_2.12.10:$version \
        org.scalameta:mtags_2.12.9:$version \
        org.scalameta:mtags_2.12.8:$version \
        org.scalameta:mtags_2.11.12:$version"