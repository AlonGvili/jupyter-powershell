# Copyright (c) 2020 Trevor Sullivan

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM python:buster

# Install Jupyter package and PowerShell "kernel" for Jupyter
WORKDIR /app

ADD [".", "/app/"]

RUN pip install jupyterlab powershell_kernel \
  && python -m powershell_kernel.install \
  && mkdir /home/python \
  && useradd --home-dir /home/python --shell /bin/bash python \
  && chown -R python /home/python

# Install PowerShell for Debian 10 (Buster) and dependencies
# NOTE: PowerShell v7 or later is required for Debian 10, according to Microsoft documentation
ARG PS_VERSION=7.0.0-rc.1
ARG PS_PACKAGE=powershell-preview_${PS_VERSION}-1.debian.10_amd64.deb
ARG PS_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/${PS_PACKAGE}

ADD ${PS_PACKAGE_URL} /tmp/powershell.deb

RUN apt-get update \
  && apt-get install apt-utils --yes \
  && apt-get install /tmp/powershell.deb less locales gss-ntlmssp --yes \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm /tmp/powershell.deb

# Add PowerShell install directory to $PATH, else it can't be located
ENV PATH="/opt/microsoft/powershell/7-preview:${PATH}"

# Best practice: Run container under a non-root user
USER python

# Expose Jupyter on TCP port 8080
EXPOSE 8080

# Set the working directory to non-root user's $HOME directory, so Jupyter UI works correctly
WORKDIR /home/python

# Set the entrypoint for the container image
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8080"]