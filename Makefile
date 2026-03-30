# This file is a part of Kinecat
#
# Kinecat is free software: you can redistribute it and/or modify it under the
# terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# Kinecat is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <https://www.gnu.org/licenses/>. 

PYTHON=python3
VENV=.venv

setup:
	$(PYTHON) -m venv $(VENV)
	source $(VENV)/bin/activate && \
	python -m pip install --upgrade pip setuptools wheel && \
	pip install -r requirements.txt
	@echo "✅ Setup complete."

run:
	source $(VENV)/bin/activate && python kinecat.py

clean:
	rm -rf $(VENV)
	@echo "🧹 Cleaned project"