# -*- mode: yaml -*-
# vi: set ft=yaml :

base:
  pkgrepo.managed:
    - humanname: Deadsnakes PPA
    - name: ppa:fkrull/deadsnakes
    - dist: precise
    - file: /etc/apt/sources.list.d/deadsnakes.list
    - keyid: DB82666C
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: python3.4

python3.4:
  pkg.installed

packges:
  pkg.installed:
    - pkgs:
      - gfortran
      - git
      - htop
      - libagg-dev
      - libatlas-base-dev
      - libatlas-dev
      - libblas-dev
      - libfreetype6-dev
      - libjpeg8-dev
      - liblapack-dev
      - libpng-dev
      - mercurial
      - openjdk-7-jre-headless
      - prover9
      - python2.6
      - python2.6-dev
      - python3.3
      - python3.3-dev
      - python3.4-dev

to_remove:
  pkg.removed:
    - pkgs:
      - python3.2
      - python3.2-dev
      - nodejs
      - postgresql-client-9.3
      - openjdk-6-jre
      - memcached
      - mongodb

{% for py in ['2.6', '2.7', '3.3', '3.4'] %}
ez_setup_{{ py }}:
  cmd.run:
    - name: python{{ py }} /bin/ez_setup.py
    - require:
      - file: /bin/ez_setup.py

pip_{{ py}}:
  cmd.run:
    - name: easy_install-{{ py }} pip
    - require:
      - cmd: ez_setup_{{ py }}

wheel_{{ py }}:
  pip.installed:
    - name: wheel
    - bin_env: pip{{ py }}
    - require:
      - cmd: pip_{{ py }}

numpy_{{  py }}:
  pip.installed:
    - name: numpy
    - bin_env: pip{{ py }}
    - use_wheel: True
    - require:
      - pip: wheel_{{ py }}

scipy_{{  py }}:
  pip.installed:
    - name: scipy
    - bin_env: pip{{ py }}
    - use_wheel: True
    - require:
      - pip: numpy_{{ py }}

scikit-learn_{{  py }}:
  pip.installed:
    - name: scikit-learn
    - bin_env: pip{{ py }}
    - use_wheel: True
    - require:
      - pip: scipy_{{ py }}

{% for package in [
  'matplotlib',
  'nltk',
  'nose',
  'pyparsing',
  'python-dateutil',
  'tornado',
] %}

{{ py }}_{{ package }}:
  pip.installed:
    - name: {{ package }}
    - bin_env: pip{{ py }}
    - use_wheel: True
    - require:
      - pip: scikit-learn_{{  py }}
{% endfor %}

{% endfor %}

tox:
  pip.installed:
    - bin_env: pip2.6
    - require:
      - cmd: pip_2.6

# coveralls:
#   pip.installed
#

nltk_data:
  cmd.run:
    - name: python -m nltk.downloader -d /usr/share/nltk_data all

malt:
  archive:
    - extracted
    - name: /opt/
    - source: http://maltparser.org/dist/maltparser-1.8.tar.gz
    - archive_format: tar
    - tar_options: z
    - source_hash: sha512=e613c20ad7dfe06a7698e059d7eb18cd1120985afedb043e8e6991bae54136d7ac844e078483e5530e541e3f526e8f2eae4e61594b79671d94531dbfefbb17cc
    - if_missing: /opt/maltparser-1.8

/opt/maltparser-1.8/malt.jar:
  file.symlink:
    - target: /opt/maltparser-1.8/maltparser-1.8.jar

hunpos:
  archive:
    - extracted
    - name: /opt/
    - source: https://hunpos.googlecode.com/files/hunpos-1.0-linux.tgz
    - archive_format: tar
    - tar_options: z
    - source_hash: sha512=2b15136e5f5b8bb4cf5c38715cab3e810d60192e9404d15d329fb788b95b92c582ffe982892a7d2d470b061e6f1bea3fa051138dc820d19280234275cbd9ddeb
    - if_missing: /opt/hunpos-1.0-linux/

senna:
  archive:
    - extracted
    - name: /usr/share
    - source: http://ml.nec-labs.com/senna/senna-v2.0/senna-v2.0.tgz
    - archive_format: tar
    - tar_options: z
    - source_hash: sha512= a98cf218b9a059ac70b9ef36a28d6c9c68b76e95c2cd7facfb21bc8e5787a91f2c47022f3a36cbb8c5abf5e2962bc5db58effabf04fc69f9caa23be3827de92d
    - if_missing: /usr/share/senna-v2.0

/bin/megam:
  file.managed:
    - source: https://dl.dropboxusercontent.com/u/50040986/index/megam
    - user: root
    - group: root
    - mode: '0755'
    - source_hash: sha512=32999071f2365972022b78659d4135cd45897a15b4361d49b570876956b41d8f063b9bb351c18ac010b399edd9a616ccf2fe538e1d3e38eb5a763b6be6046466

/bin/ez_setup.py:
  file.managed:
    - source: https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
    - user: root
    - group: root
    - mode: '0755'
    - source_hash: sha512=4b0af5c60c2156c55b61b59e0e0cb99cd7201433a36fefda35e7047bf30413ea91c79c5308c3ba64d92fff54935e1a5f5bcebe329822dcf505c612065835fa10
