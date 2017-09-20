
-- Wypisz imiona i nazwiska uczniów w grupach w bieżącym semestrze
select s.nazwa,g.nazwa,u.imie,u.nazwisko 
from t_grupy g
inner join t_semestry s on s.id_semestru=g.id_semestru
inner join t_uczniowe_w_grupie ug on ug.id_grupy=g.id_grupy
inner join t_uczniowie u on u.id_ucznia=ug.id_ucznia 
where s.data_od<curdate() and coalesce(s.data_do,curdate())>=curdate()
and ug.data_od<curdate() and coalesce(ug.data_do,curdate())>=curdate()
order by s.nazwa,g.nazwa,u.nazwisko, u.imie;

-- Wypisz ile uczniów jest w grupach w bieżącym semestrze (na dziś)
-- oraz jaka jest stawka za lekcję dla ucznia w tej grupie (zależy od liczebności grupy!)
-- oraz jaki jest dochód od uczniów (zał., że wszyscy przyjdą)
-- oraz jaki jest koszt nauczyciela (zał., ze bez zastepstwa)
-- oraz jaka jest róznica między przychodem od uczniów a kosztem nauczyciela
-- to wszystko w zalezności od dlugości trwania lekcji
select a.*,concat(su.cena_std,' PLN') as cena_dla_ucznia, d.dlugosc
	, concat(sn.cena_std,' PLN') as koszt_nauczyciela
    , concat(a.liczba_uczniow*su.cena_std,' PLN') as przychod_od_uczniow
    , concat(a.liczba_uczniow*su.cena_std-sn.cena_std,' PLN') as bilans
from  (
	select g.nazwa,count(*) as liczba_uczniow
	from t_grupy g
	inner join t_semestry s on s.id_semestru=g.id_semestru
	inner join t_uczniowe_w_grupie ug on ug.id_grupy=g.id_grupy
	inner join t_uczniowie u on u.id_ucznia=ug.id_ucznia 
	where s.data_od<curdate() and coalesce(s.data_do,curdate())>=curdate()
	and ug.data_od<curdate() and coalesce(ug.data_do,curdate())>=curdate()
	group by g.nazwa
) a
inner join t_stawki_uczniow su 
	on 
		su.liczebnosc_grupy_od<=a.liczba_uczniow 
        and su.liczebnosc_grupy_do>=a.liczba_uczniow
        and su.data_od<=curdate() and coalesce(su.data_do,curdate())>=curdate()
inner join t_stawki_nauczycieli sn
	on
		sn.liczebnosc_grupy_od<=a.liczba_uczniow 
        and sn.liczebnosc_grupy_do>=a.liczba_uczniow
        and sn.data_od<=curdate() and coalesce(sn.data_do,curdate())>=curdate()
inner join t_dlugosci d 
	on d.id_dlugosci=su.id_dlugosci        
		and d.id_dlugosci=sn.id_dlugosci        
order by a.nazwa, d.dlugosc;




-- Wypisz ile uczniów jest w grupach w bieżącym semestrze (na dziś)
-- oraz jaki jest dochód od uczniów (zał., że przyjdzie tylko jeden)
-- oraz jaki jest koszt nauczyciela (zał., ze będzie zastepstwo)
-- oraz jaka jest róznica między przychodem od uczniów a kosztem nauczyciela
-- to wszystko w zalezności od dlugości trwania lekcji
select a.*, d.dlugosc
	, concat(sn.cena_zast,' PLN') as koszt_nauczyciela
    , concat((a.liczba_uczniow-1)*su.cena_nieob+su.cena_std,' PLN') as przychod_od_uczniow
    , concat((a.liczba_uczniow-1)*su.cena_nieob+su.cena_std-sn.cena_zast,' PLN') as bilans
from  (
	select g.nazwa,count(*) as liczba_uczniow
	from t_grupy g
	inner join t_semestry s on s.id_semestru=g.id_semestru
	inner join t_uczniowe_w_grupie ug on ug.id_grupy=g.id_grupy
	inner join t_uczniowie u on u.id_ucznia=ug.id_ucznia 
	where s.data_od<curdate() and coalesce(s.data_do,curdate())>=curdate()
	and ug.data_od<curdate() and coalesce(ug.data_do,curdate())>=curdate()
	group by g.nazwa
) a
inner join t_stawki_uczniow su 
	on 
		su.liczebnosc_grupy_od<=a.liczba_uczniow 
        and su.liczebnosc_grupy_do>=a.liczba_uczniow
        and su.data_od<=curdate() and coalesce(su.data_do,curdate())>=curdate()
inner join t_stawki_nauczycieli sn
	on
		sn.liczebnosc_grupy_od<=a.liczba_uczniow 
        and sn.liczebnosc_grupy_do>=a.liczba_uczniow
        and sn.data_od<=curdate() and coalesce(sn.data_do,curdate())>=curdate()
inner join t_dlugosci d 
	on d.id_dlugosci=su.id_dlugosci        
		and d.id_dlugosci=sn.id_dlugosci        
order by a.nazwa, d.dlugosc;
