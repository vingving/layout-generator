KLAYOUT = klayout -zz -e -j . -r
# -zz=GUI없이 실행, -e=종료 안 함, -j .=현재 디렉토리 import path에 추가, -r=스크립트 실행
VPATH = ./layouts

all: via_test.oas
# make all 실행 시 기본적으로 via_test.oas 파일을 만들도록 설정

# $@ → 타겟 파일 이름
# $< → 첫 번째 prerequisite
# $+ → 모든 prerequisite
# $(word n, $+) → n번째 prerequisite

m2_%.oas: configs/m2_%.csv ./src/m2.py
	mkdir -p layouts
	$(KLAYOUT) $(word 2,$+) -rd csv_file=$< -rd dest=./layouts -rd outOAS=$@ -rd outLayer=1/0

via_%.oas: configs/via_%.csv ./src/via1.py
	$(KLAYOUT) $(word 2,$+) -rd csv_file=$< -rd dest=./layouts -rd outOAS=$@ -rd outLayer=2/0
	zip -r ./layouts/via.zip ./layouts

m2_drc.gds: configs/m2_drcb.csv ./src/m2_drc.py
	$(KLAYOUT) $(word 2,$+) -rd csv_file=$< -rd dest=./layouts -rd outOAS=$@ -rd outLayer=2/0
	# generate conflict cells images
	cd src && python gds2img.py ../layouts/ ../layouts/ 1
	cd src && python gds2img.py ../layouts/ ../layouts/ 2
	zip -r ./layouts/m2_drc.zip ./layouts 

hilbert_test: configs/hilbert_test.csv ./src/hilbert.py
	$(KLAYOUT) $(word 2,$+) -rd csv_file=$< -rd dest=./layouts -rd outOAS=$@ -rd outLayer=2/0

peano_test: configs/peano_test.csv ./src/peano.py
	$(KLAYOUT) $(word 2,$+) -rd csv_file=$< -rd dest=./layouts -rd outOAS=$@ -rd outLayer=2/0


m2_ww.oas: configs/m2_ww.csv configs/m2_ww_drc.csv ./src/m2.py
	mkdir -p layouts
	$(KLAYOUT) $(word 3,$+) -rd csv_file=$< -rd drc_file=$(word 2,$+) -rd dest=./layouts -rd outOAS=$@ -rd outLayer=1/0

iccad13:
	mkdir -p iccad13
	$(KLAYOUT) src/iccad13_gen.py

clean:

	rm -rf layouts/*

