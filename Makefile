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