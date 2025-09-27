import sys
sys.path.append('./src')

from LayoutGenerator import *
import os
from progress.bar import Bar

se = shape_enumerator("./data/iccad13_base")



se.get_shape_lib()
#se._generate_rule_cell()

#se.search_step = 70
#se._draw_lib()



clip_num_per_density=4200
# 한 가지 spacing 값마다 4200개의 레이아웃(clip)을 생성

for i in range(40, 80, 10):
    se.spacing=i
    bar = Bar("enumerating layouts spacing %g"%i, max=clip_num_per_density)
    for pc in range(clip_num_per_density):
        se.draw_layout()
        bar.next()
    
    bar.finish()




