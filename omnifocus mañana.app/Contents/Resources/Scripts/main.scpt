FasdUAS 1.101.10   ��   ��    k             l     ��  ��    D > Get the selection FIRST and then exit if nothing is selected.     � 	 	 |   G e t   t h e   s e l e c t i o n   F I R S T   a n d   t h e n   e x i t   i f   n o t h i n g   i s   s e l e c t e d .   
  
 l    ? ����  O     ?    O    >    k    =       r    .    n    ,    1   * ,��
�� 
valL  l   * ����  6  *    2   ��
�� 
OTst  F    )    l    ����  >       n       !   m    ��
�� 
pcls ! n    " # " 1    ��
�� 
valL #  g      m    ��
�� 
cobj��  ��    l   ( $���� $ >   ( % & % n     $ ' ( ' m   " $��
�� 
pcls ( n    " ) * ) 1     "��
�� 
valL *  g       & m   % '��
�� 
FCAr��  ��  ��  ��    o      ���� 0 tasksselected tasksSelected   +�� + Z   / = , -���� , =  / 4 . / . n   / 2 0 1 0 1   0 2��
�� 
leng 1 o   / 0���� 0 tasksselected tasksSelected / m   2 3����   - k   7 9 2 2  3 4 3 l  7 7�� 5 6��   5 ? 9			display alert "You didn't select any OmniFocus tasks."    6 � 7 7 r 	 	 	 d i s p l a y   a l e r t   " Y o u   d i d n ' t   s e l e c t   a n y   O m n i F o c u s   t a s k s . " 4  8�� 8 L   7 9����  ��  ��  ��  ��    n     9 : 9 1    ��
�� 
FCcn : n     ; < ; 4   �� =
�� 
FCdw = m   	 
����  < 4   �� >
�� 
docu > m    ����   m      ? ?�                                                                                  OFOC  alis    $  lucky13                        BD ����OmniFocus.app                                                  ����            ����  
 cu             Applications  /:Applications:OmniFocus.app/     O m n i F o c u s . a p p    l u c k y 1 3  Applications/OmniFocus.app  / ��  ��  ��     @ A @ l     �� B C��   B H B Do the actual work of setting the date and the flag, if necessary    C � D D �   D o   t h e   a c t u a l   w o r k   o f   s e t t i n g   t h e   d a t e   a n d   t h e   f l a g ,   i f   n e c e s s a r y A  E F E l  @ � G���� G O   @ � H I H Y   D � J�� K L�� J O   Q � M N M k   X � O O  P Q P r   X _ R S R l  X ] T���� T ]   X ] U V U ]   X [ W X W m   X Y����  X m   Y Z���� < V m   [ \���� <��  ��   S o      ���� 
0 oneday   Q  Y Z Y l  ` `��������  ��  ��   Z  [ \ [ r   ` k ] ^ ] [   ` g _ ` _ l  ` e a���� a I  ` e������
�� .misccurdldt    ��� null��  ��  ��  ��   ` o   e f���� 
0 oneday   ^ o      ���� 
0 manana   \  b c b r   l u d e d m   l m����   e n       f g f 1   p t��
�� 
time g o   m p���� 
0 manana   c  h i h l  v v��������  ��  ��   i  j k j r   v  l m l n   v { n o n 1   w {��
�� 
FCDd o  g   v w m o      ���� 
0 olddue   k  p q p Z   � � r s���� r >  � � t u t o   � ����� 
0 olddue   u m   � ���
�� 
msng s k   � � v v  w x w r   � � y z y o   � ����� 
0 manana   z o      ���� 0 duet   x  { | { r   � � } ~ } l  � � ����  n   � � � � � 1   � ���
�� 
time � o   � ����� 
0 olddue  ��  ��   ~ n       � � � 1   � ���
�� 
time � o   � ����� 0 duet   |  ��� � r   � � � � � o   � ����� 0 duet   � n       � � � 1   � ���
�� 
FCDd �  g   � ���  ��  ��   q  � � � l  � ���������  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
FCDs �  g   � � � o      ���� 0 olddefer   �  � � � Z   � � � ��� � � =  � � � � � o   � ����� 0 olddefer   � m   � ���
�� 
msng � r   � � � � � o   � ����� 
0 manana   � n       � � � 1   � ���
�� 
FCDs �  g   � ���   � k   � � � �  � � � r   � � � � � o   � ����� 
0 manana   � o      ���� 
0 defert   �  � � � r   � � � � � l  � � ����� � n   � � � � � 1   � ���
�� 
time � o   � ����� 0 olddefer  ��  ��   � n       � � � 1   � ���
�� 
time � o   � ����� 
0 defert   �  ��� � r   � � � � � o   � ����� 
0 defert   � n       � � � 1   � ���
�� 
FCDs �  g   � ���   �  � � � l  � ���������  ��  ��   �  ��� � l  � ���������  ��  ��  ��   N n   Q U � � � 4   R U�� �
�� 
cobj � o   S T���� 0 i   � o   Q R���� 0 tasksselected tasksSelected�� 0 i   K m   G H����  L l  H L ����� � n   H L � � � 1   I K��
�� 
leng � o   H I���� 0 tasksselected tasksSelected��  ��  ��   I m   @ A � ��                                                                                  OFOC  alis    $  lucky13                        BD ����OmniFocus.app                                                  ����            ����  
 cu             Applications  /:Applications:OmniFocus.app/     O m n i F o c u s . a p p    l u c k y 1 3  Applications/OmniFocus.app  / ��  ��  ��   F  ��� � l     ��������  ��  ��  ��       
�� � � ��� ����� �����   � ��������~�}�|�{
�� .aevtoappnull  �   � ****�� 0 tasksselected tasksSelected�� 
0 oneday  � 
0 manana  �~ 
0 olddue  �} 0 olddefer  �| 
0 defert  �{   � �z ��y�x � ��w
�z .aevtoappnull  �   � **** � k     � � �  
 � �  E�v�v  �y  �x   � �u�u 0 i   �  ?�t�s�r�q ��p�o�n�m�l�k�j�i�h�g�f�e�d�c�b�a�`�_�^
�t 
docu
�s 
FCdw
�r 
FCcn
�q 
OTst �  
�p 
valL
�o 
pcls
�n 
cobj
�m 
FCAr�l 0 tasksselected tasksSelected
�k 
leng�j �i <�h 
0 oneday  
�g .misccurdldt    ��� null�f 
0 manana  
�e 
time
�d 
FCDd�c 
0 olddue  
�b 
msng�a 0 duet  
�` 
FCDs�_ 0 olddefer  �^ 
0 defert  �w �� <*�k/�k/�, /*�-�[[�,�,\Z�9\[�,�,\Z�9A1�,E�O��,j  hY hUUO� � �k��,Ekh  ��/ ��� � E�O*j �E` Oj_ a ,FO*a ,E` O_ a  &_ E` O_ a ,_ a ,FO_ *a ,FY hO*a ,E` O_ a   _ *a ,FY #_ E` O_ a ,_ a ,FO_ *a ,FOPU[OY�WU � �] ��]  �   � �  � �  ��\ ��[ �  ?�Z
�Z 
FCDo
�\ 
FCac � � � �  b 0 c M 7 x V T 0 z j
�[ kfrmID  ��  Q� � ldt     �[��
�� 
msng
�� 
msng � ldt     ֛����   ascr  ��ޭ