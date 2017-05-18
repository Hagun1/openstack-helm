#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
set -ex

export HELM_VERSION=${2:-v2.3.0}
export KUBE_VERSION=${3:-v1.6.0}
export KUBECONFIG=${HOME}/.kubeadm-aio/admin.conf
export KUBEADM_IMAGE=openstackhelm/kubeadm-aio:v1.6

export WORK_DIR=$(pwd)
source ${WORK_DIR}/tools/gate/funcs/helm.sh

helm_install
helm_serve
helm_lint

if [ "x$INTEGRATION" == "xaio" ]; then
 bash ${WORK_DIR}/tools/gate/kubeadm_aio.sh
 if [ "x$INTEGRATION_TYPE" == "xbasic" ]; then
   bash ${WORK_DIR}/tools/gate/basic_launch.sh
 fi
fi
