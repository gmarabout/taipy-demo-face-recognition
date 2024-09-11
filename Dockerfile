# Copyright 2021-2024 Avaiga Private Limited
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

FROM python:3.11

WORKDIR /app

# Install application dependencies.
COPY src/requirements.txt .
RUN pip install -r requirements.txt

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash && apt install nodejs

# Install the node components.
COPY src/webcam/webui /tmp/webui
RUN npm i /tmp/webui/

# Copy the application source code.
COPY src .

# Build the extension.
RUN  cd webcam/webui && rm package-lock.json && npm i && \
    npm i /usr/local/lib/python3.11/site-packages/taipy/gui/webapp && \
    npm run build && cd -

CMD ["taipy", "run", "--no-debug", "--no-reloader", "main.py", "-H", "0.0.0.0", "-P", "5000"]