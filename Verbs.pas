program diamonds;
//программа для поиска глаголов в текстовом файле
uses crt, prg2; //модуль prg2 содержит процедуру для получения текущих даты и времени

const
  MAX=33; //максимльное число окончаний каждого вида
          //(можно изменить по усмотрению пользователя)
  
   
  nm1='in.txt';          //имя входного файла с текстом
  nm2='characters.txt';  //имя файла с окончаниями 
  nm3='in_new.txt';      //имя промежуточного файла
  nm4='out';             //часть имени выходного файла
  ext='.txt';            //расширение выходного файла
  

type
  vector1=array[1..MAX] of string[2]; //массив оконаний в 2 буквы
  vector2=array[1..MAX] of string[3]; // -//- в 3 буквы
  vector3=array[1..MAX] of string[4]; // -//- в 4 буквы
  
type plist=^tlist;     //указатель
   tlist=record
     next: plist;      //указатель на следующий элемент
     number: integer;  //количество повторений глагола
     glag: string[20]; //глагол 
     procent: real;    //процент количества появлений определенного глагола
   end;

     

var
   ending1: vector1; //массив окончаний в 2 буквы
   ending2: vector2; //массив окончаний в 3 буквы
   ending3: vector3; //массив окончаний в 4 буквы
   h, q: text;       // переменные для текстовых файлов
   counter, cntr: word; //счетчики слов
   n: char;          // код нажатой клавиши 
   percent: real;    // процент содержания глаголов
   first: plist;     //указатель
   list : plist;     //указатель
   p : plist;        //указатель
   wrd: string[20];  //слово
   name: string;     //имя выходного файла
   ch2: word;        //количество окончаний в 2 буквы
   ch3: word;        // -//- в 3 буквы
   ch4: word;        // -//- в 4 буквы
   
   
   
   
//-----конец раздела описаний----------------------------------

procedure Menu;
//процедура для вывода меню на экран
begin 
  writeln('Нажмите "1" для вывода данных на экран');
  writeln('Нажмите "2" для вывода данных в текстовый файл'); 
  writeln('Нажмите "0" для выхода'); 
  writeln;
end;  

//-------------------------------------------------------------  
   
Function CaseOfEmptiness: boolean;
//функция для установления факта
//непустоты входного файла

var
    f: text; //файловая переменная
  
begin //func

    assign(f, nm1); //открываем на чтение входной файл
    reset(f);

      if eof(f) then
      //если он пуст, то показать сообщения об ошибке
        begin //0
          writeln('Файл ', nm1, ' не заполнен!');
          writeln('Введите в него текст и повторите попытку');
          CaseOfEmptiness:= false;
        end //0
  
        else //если же файл не пуст, то продолжить работу
          begin
            writeln('Началась обработка файла ' , nm1);
            writeln;
            CaseOfEmptiness:= true;
          end;
    close(f);
end; //func

//_______________________________________________________________


Procedure Element;  
// процедура для заполнения массивов
//глагольными окончаниями
var
  i, j, k: integer; //счетчики циклов
  str: string[4];   //вспомогательная переменная
  len: integer;     //длина строки
  
begin //proc

ch2:=0; //изначально количество
ch3:=0; //всех окончаний
ch4:=0; //равно нулю
    
    assign(h, nm2); //открываем файл с окончаниями
    reset(h);
    
    while not eof(h) do
      begin
        readln(h,  str);
        len:=length(str);
          if len=2 then
            inc(ch2);      //считаем количество окончаний в 2 символа
          if len=3 then
            inc(ch3);      // -//- в 3 символа
          if len=4 then
            inc(ch4);      // -//- в 4 символа
      end;
    close(h);
      
      
    assign(h, nm2);  
    reset(h);
  i:=1; j:=1; k:=1; //начальная индексция в массивах
  
   while not eof(h) do
     begin
     
       readln(h, str);
       
         if length(str)=2 then
          begin
            ending1[i]:=str;     //если найдено окончание в 2 символа,
            inc(i);              //записываем его в соответствующий массив
          end;
          
         if length(str)=3 then
          begin
            ending2[j]:=str;     //если найдено окончание в 3 символа,
            inc(j);              //записываем его в соответствующий массив
          end;
          
         if length(str)=4 then
          begin
            ending3[k]:=str;     //если найдено окончание в 4 символа,
            inc(k);              //записываем его в соответствующий массив
          end;
     end;
   
   close(h);
    
end; //proc     

//---------------------------------------------------


Procedure OKE;
//процедура для перевода букв в нижний регистр
//и удаления знаков препинания

var
    S: char;         //код символа
    f, q: text;      //файловые переменные
    Al: set of char; //множество символов 
  
  
Begin //proc

   Al:=['а'..'я', 'А'..'Я', #32]; // зададим множество символов
   
    assign(f, nm1); //открываем исходный файл
    reset(f);

         assign(q, nm3); //открываем промежуточный файл
         rewrite(q);

   while not eof(f) do
     begin //0
       read(f, S); //читаем каждый элемент
        if S in Al then 
          begin //1
            if (ord(S)<224) and (ord(S)<>32) then
         
             S:=chr(ord(S)+32); //переводим в нижний регистр
             write(q, S);       //записываем в промежуточный файл
                  
          end; //1
     end;//0
     
         close(q);
    close(f);

End; //proc

//___________________________________________________________

Procedure CounterOW;
//процедура для подсчета общего
//числа слов в тексте

var 
    q: text;   //текстовая переменная
    W: string; //служебная переменная
    i: integer;//служебная переменная 
    
begin //proc
   assign(q, nm3); //открываем промежуточны файл
   reset(q);
   cntr:=0; //обнуляем счетчик
   
      while not (eof(q)) do
        begin
          readln(q, W);
          for i:=1 to length(W)-1 do
             if (W[i]=' ') and (W[i+1]<>' ') then 
             inc(cntr); //если что-то находится между пробелами,
                       //то уеличиваем количество слов
        end;
        
   close(q);

end; //proc

//___________________________________________________________

procedure sort;
// процедура для сортировки динамического списка
//в порядке убывания числа одинаковых глаголов
 
var 
   t,tp: plist; //указатели
   
begin //proc
//р указывает на элт стоящий перед элтом, который содерж повт-ся глагол
   t:=list;               //указ на 1ый эл в списке
   tp:=p^.next;           //указ на элт содерж повт глаг
   while (t^.next<>nil ) do 
     begin //0
       if (tp^.number < t^.next^.number) then
          t:=t^.next //сдвиг на след элт
       else 
          break;
     end; //0
     
   p^.next:=tp^.next;  //перемещ ук-ль через 1 эл-т
   tp^.next:=t^.next;  //перебрас ук-ль туда, после которого идут глаг с меньш number
   t^.next:=tp;  //указатель ушел на место, где стоял перемещ элт
   
end; //proc

//-----------------------------------------------

procedure rec;
//процедура для заполнения динамического
//списка глаголами и параметрами

begin //proc
   p := list;  //указатель на первый элемент
                 
   while (p^.next <> nil) do 
     begin //0   
       if (p^.next^.glag<>wrd) //если глагол находящийся в следующем элементе еще не встречался
         then p:=p^.next //переместить указатель на слежующий элемент
       else break;
     end; //0
                        
         if (p^.next = nil) then //повторяющихся не было
           begin //1
             new(first^.next);      //создаем новый элемент в конце спика
             first := first^.next;  //указатель сдвигается на новый последний элемент
             first^.glag:=wrd;      //записываем новый глагол
             first^.number :=1;
             first^.next := nil; 
           end //1
                        
         else
           begin //2
             inc(p^.next^.number);  //увеличиваем число повторений глагола
             sort;
           end; //2
                    
end; //proc
              
//-----------------------------------------------

Procedure VerbsTXT;
//процедура для нахождения глаголов
//в отредактированном тексте и подсчета их количества

var
    w: string;               //служебная переменная
    q: text;                 //файловая переменная
    i, k, j, l, y: integer;  //служебные переменные
    len :integer;            //длина строки 
    

begin //proc

counter:=0; //обнуляем количество глаголов

  New (list);
  list^.next:=nil;  //изначально список пуст
  list^.number:=0;  //изначально глаголов нет
  first := list;    


    assign(q, nm3); //открываем промежуточный файл
    reset(q);

while not (eof(q)) do
  begin //0
    readln(q, w);
    k:=0;
    len := length(w);
    
    for j:=1 to len do
      begin //1
        if (w[j]=' ') then  //считываем строку до пробела
           begin //2
             wrd:= copy(w, k, j-k); //заносим слово в перменную 
             k:=j+1;
              
               for i:=1 to ch2 do
                begin//3
              
                 if length(wrd)>4 then
                   begin//4
              
                    if PosEx(ending1[i], wrd, (length(wrd)-1))<>0 then
                     begin //7
                      //если в слове попадается нужное окончание,
                      //оно будет считаться глаголом
                      inc(counter); //увеличиваем количество глаголов
                      rec; //добавляем глагол в динамический список
                     end; //7
                   end; //4
                end; //3
               
              
              
              for l:=1 to ch3 do
                begin //5
                 if length(wrd)>4 then
                   begin //6
                     if PosEx(ending2[l], wrd, (length(wrd)-2))<>0 then
                     begin
                      //если в слове попадается нужное окончание,
                      //оно будет считаться глаголом
                      inc(counter); //увеличиваем количество глаголов
                      rec; //добавляем глагол в динамический список
                     end;
                   end; //6
                end; //5
                
                
                
                   for y:=1 to ch4 do
                     begin //7
                       if length(wrd)>4 then
                         begin //8
                           if PosEx(ending3[y], wrd, (length(wrd)-3))<>0 then
                           begin
                             //если в слове попадается нужное окончание,
                             //оно будет считаться глаголом
                             inc(counter); //увеличиваем количество глаголов
                             rec; //добавляем глагол в динамический список
                           end;
                         end; //8
                      end; //7
                           
             end; //2
          end; //1
    
    end; //0
close(q);      


    if counter=0 then
               writeln('Глаголов не найдено');


end; //proc


Begin //main prg
clrscr;

writeln('Данная  програма  предназначена для');
writeln('поиска глаголов по текстовому файлу');
writeln;
writeln('Меню:');
Menu; //вывод меню на экран



repeat
                n:=readkey; 
               
                case n of
                        '1': begin // вывод на экран
                                if (CaseOfEmptiness=false) then
                                  halt(1) //выходим если файл пуст
                                else
                                  begin //0
                                    
                                    writeln;
                                    Element;
                                    OKE;
                                    CounterOW;
                                    VerbsTXT;
                                    if counter<>0 then
                                      writeln('Найдены глаголы: ')
                                    else
                                      writeln('Глаголов не найдено');
                                     first:=list;
                                     writeln('__Список глаголов___:_Количество_:_Процент_');
                                      while (first^.next<>nil)do
                                       begin
                                        first:=first^.next;
                                        first^.procent:=first^.number/cntr*100; //подсчитываем процент содержания каждого глагола в тексте
                                        
                                        writeln(first^.glag:20,'  ' , first^.number:12, '   ', first^.procent:2:3, '%');
                                       end;
                                    
                                    writeln('_______________________');
                                    writeln('Количество глаголов: ', counter);
                                    writeln('Общее количество слов: ', cntr);
                                    percent:=counter/cntr*100;
                                    writeln('В данном тексте содержится  ', percent:2:3, ' % глаголов');
                                    writeln('Работа завершена, нажмите Enter');
                                    readln;
                                    writeln;
                                    Menu;
                                  end //0
                             end;
                             
                        '2': begin //вывод в текстовый файл
                                DT; //получаем системные дату и время
                                name:=nm4+vremya+ext; //таким будет имя выходного файла
                                
                                assign(q, name);
                                rewrite(q);
                                writeln('Идет обработка файла ', nm1);
                                writeln('Информация добавлена в файл "', name, '"');
                                    Element;
                                    OKE;
                                    CounterOW;
                                    VerbsTXT;
                                    
                                     
                                   first:=list;
                                   writeln(q, '__Список глаголов___:_Количество_:_Процент_');
                                   while (first^.next<>nil)do
                                    begin
                                        first:=first^.next;
                                        first^.procent:=first^.number/cntr*100; //подсчитываем процент содержания каждого глагола в тексте
                                        writeln(q, first^.glag:20,'  ' , first^.number:20, '             ', first^.procent:2:3, '%');
                                    end;
                                    
                                  writeln(q, '_______________________');
                                    writeln(q, 'Количество глаголов: ', counter);
                                    writeln(q, 'Общее количество слов: ', cntr);
                                    percent:=counter/cntr*100;
                                    writeln(q, 'В данном тексте содержится  ', percent:2:3, ' % глаголов');  
                                    close(q);
                                
                                writeln('Работа завершена, нажмите Enter');
                                readln;
                                writeln;
                                Menu;
                                
                             end;
                 end;
  until n='0';
 
End. //main prg



//внешний модуль:

Unit prg2;

   interface
     uses system; //используем эту библиотеку для доступа к дате и времени
     
     var
         d1: DateTime;       
         vremya: string[20]; //в эту строку будут записаны дата и время
         
         procedure DT;       //процедура получающая и преобразующая
                             //целочисленные дату и время к строковому представлению
         
         
   implementation
     
     procedure DT;
       begin 
         d1 := DateTime.Now; 
           
         vremya:= IntToStr(d1.Day) + '_' + IntToStr(d1.Month) + '_' + IntToStr(d1.year) + '-' + IntToStr(d1.Hour) + '_' + IntToStr(d1.Minute) + '_' + IntToStr(d1.Second);
         //получаем строку из целых чисел с разделителями
       end;
       
   initialization
end.
