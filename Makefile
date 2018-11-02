requirements:
	pip install -r requirements.txt --trusted-host pypi.org --trusted-host files.pypi.org --trusted-host files.pythonhosted.org

secrets:
	python manage.py generate_secret

collectstatic:
	python manage.py collectstatic

html:
	(rm -rf docs/build/html)
	(rm -rf docs/build/doctrees)
	cp vespene/static/png/vespene_logo.png docs/source/
	(cd docs; make html)

docs_publish:
	cp -a docs/build/html/* ../vespene-io.github.io/

indent_check:
	pep8 --select E111 vespene/

pyflakes:
	pyflakes vespene/
	pyflakes vespene/views/*.py

worker:
	ssh-agent env/bin/python manage.py worker general

tutorial_setup:
	env/bin/python manage.py tutorial_setup

clean:
	find . -name '*.pyc' | xargs rm -r
	find . -name '__pycache__' | xargs rm -rf

migrations:
	PYTHONPATH=. env/bin/python manage.py makemigrations vespene

migrate:
	PYTHONPATH=. env/bin/python manage.py migrate
	PYTHONPATH=. env/bin/python manage.py migrate vespene

superuser:
	PYTHONPATH=. env/bin/python manage.py createsuperuser

changepassword:
	PYTHONPATH=. env/bin/python manage.py changepassword

uwsgi:
	uwsgi --http :8003 --wsgi-file vespene/wsgi.py -H env --plugins python3 --static-map /static=static

supervisor_setup_example:
    PYTHONPATH=. env/bin/python manage.py supervisor_generate --executable /usr/bin/python --controller true --workers "tutorial-pool=2"

run:
	PYTHONPATH=. env/bin/python manage.py runserver

todo:
	grep TODO -rn vespene

bug:
	grep BUG -rn vespene

fixme:
	grep FIXME -rn vespene

gource:
	gource -s .06 -1280x720 --auto-skip-seconds .1 --hide mouse,progress,filenames --key --multi-sampling --stop-at-end --file-idle-time 0 --max-files 0  --background-colour 000000 --font-size 22 --title "Vespene" --output-ppm-stream - --output-framerate 30 | avconv -y -r 30 -f image2pipe -vcodec ppm -i - -b 65536K movie.mp4

docker: docker.server docker.worker

docker.server:
	docker build -t vespene -f ./docker/server/Dockerfile .

docker.worker:
	docker build -t vespene-worker -f ./docker/worker/Dockerfile .