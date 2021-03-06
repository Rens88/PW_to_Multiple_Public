function [resultat, cumul_effet_mpd_1,cumul_effet_mpd_2, ...
    cumul_effet_mpd_tang_1,cumul_effet_mpd_orient_1,cumul_effet_mpd_tang_2, ...
    cumul_effet_mpd_orient_2,cumul_effet_mpd_total,tti_fenetre,mpd_fenetre, ...
    effect_inst,in_motion,index_dmin,instantPassagePointCommun,effect_mpd_1,effect_mpd_2 ] = ...
    traitement_experience_MPI(center_1_flt1,center_2_flt1,time,in_motion)
% TRAITEMENT_EXPERIENCE_MPI:
% 02-08-2018 Rens Meerhoff
% For questions, contact rensmeerhoff@gmail.com.
%
% Code was used for:
% 'Collision avoidance with multiple walkers: Sequential or simultaneous interactions?'
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
% Submitted to: Frontiers in Psychology
%
% Adaptation of the code made available in the Matlab library from Anne-Helen Olivier.
%
% 26-10-2016 EDIT Rens Meerhoff:
% I changed the calculation of effect_mpd1 (line 213-214) to the absolute
% deviation in order to deal with signed MPD (which is a pain for %
% contribution calculation)


%%
%--------------------------------------------------------------------------
%           Calcul des instants de croisement
%--------------------------------------------------------------------------
milieuEpaules{1}=center_1_flt1;
milieuEpaules{2}=center_2_flt1;

% instantCroisement d?fini comme l'instant o? la distance entre les deux
% sujets est minimale

distanceSujets = zeros(length(center_1_flt1),1);
distanceSujets = sqrt(sum((milieuEpaules{1}- milieuEpaules{2}).^2,2));
[distMin, instantCroisement] = min(distanceSujets);% distance mini entre les 2 milieux des ?paules des sujets

% Recherche du point commun entre les deux trajectoires (purement
% g?om?trique, sans notion de temps)
instantPassagePointCommun = [instantCroisement, instantCroisement];
for sujet = 1:2
    passage{sujet} = milieuEpaules{sujet}(instantPassagePointCommun(sujet),1:2);
end;
pointCommunTrouve = 0;   % flag bool?en
pointCommun = [0, 0];
while ~pointCommunTrouve
    for sujet = 1:2
        [dmin, instantPassagePointCommun(sujet)] = min(sqrt(sum((milieuEpaules{sujet} - repmat(passage{3-sujet},length(milieuEpaules{sujet}),1)).^2,2)));
        passage{sujet} = milieuEpaules{sujet}(instantPassagePointCommun(sujet),1:2);
    end;
    nouveauPointCommun = 0.5*(passage{1} + passage{2});
    pointCommunTrouve = ~norm(nouveauPointCommun - pointCommun);
    pointCommun = nouveauPointCommun;
end;

center_1_flt=milieuEpaules{1};
center_2_flt=milieuEpaules{2};

velovec_1 = velocity_vector(center_1_flt, time);
velovec_2 = velocity_vector(center_2_flt, time);

[tti, mpd] = time_to_interaction_sign(center_1_flt, velovec_1, center_2_flt, velovec_2,0);

vprev_1 = [velovec_1(1,:); velovec_1(1:end-1,:)];
vprev_2 = [velovec_2(1,:); velovec_2(1:end-1,:)];
[tti_noadapt_1, mpd_noadapt_1] = time_to_interaction_sign(center_1_flt, vprev_1, center_2_flt, velovec_2,0);
[tti_noadapt_2, mpd_noadapt_2] = time_to_interaction_sign(center_1_flt, velovec_1, center_2_flt, vprev_2,0);

for i=1:length(time)
    v_no_tang_1(i,:) = norm(vprev_1(i,:)) * velovec_1(i,:) / norm(velovec_1(i,:));
    v_no_tang_2(i,:) = norm(vprev_2(i,:)) * velovec_2(i,:) / norm(velovec_2(i,:));
end

[tti_no_tang_1, mpd_no_tang_1] = time_to_interaction_sign(center_1_flt, v_no_tang_1, center_2_flt, velovec_2,0);
[tti_no_tang_2, mpd_no_tang_2] = time_to_interaction_sign(center_1_flt, velovec_1, center_2_flt, v_no_tang_2,0);


for i=1:length(time)
    v_no_orient_1(i,:) = norm(velovec_1(i,:)) * vprev_1(i,:) / norm(vprev_1(i,:));
    v_no_orient_2(i,:) = norm(velovec_2(i,:)) * vprev_2(i,:) / norm(vprev_2(i,:));
end
[tti_no_orient_1, mpd_no_orient_1] = time_to_interaction_sign(center_1_flt, v_no_orient_1, center_2_flt, velovec_2,0);
[tti_no_orient_2, mpd_no_orient_2] = time_to_interaction_sign(center_1_flt, velovec_1, center_2_flt, v_no_orient_2,0);

effect_tti_1 = tti - tti_noadapt_1;
effect_tti_2 = tti - tti_noadapt_2;
effect_mpd_1 = mpd - mpd_noadapt_1;
effect_mpd_2 = mpd - mpd_noadapt_2;

effect_tti_tang_1 = tti - tti_no_tang_1;
effect_tti_tang_2 = tti - tti_no_tang_2;
effect_mpd_tang_1 = mpd - mpd_no_tang_1;
effect_mpd_tang_2 = mpd - mpd_no_tang_2;

effect_tti_orient_1 = tti - tti_no_orient_1;
effect_tti_orient_2 = tti - tti_no_orient_2;
effect_mpd_orient_1 = mpd - mpd_no_orient_1;
effect_mpd_orient_2 = mpd - mpd_no_orient_2;


cumul_effet_mpd_total = zeros (size(time));
cumul_effet_mpd_1 = zeros (size(time));
cumul_effet_mpd_2 = zeros (size(time));
cumul_effet_mpd_tang_1 = zeros (size(time));
cumul_effet_mpd_orient_1 = zeros (size(time));
cumul_effet_mpd_tang_2 = zeros (size(time));
cumul_effet_mpd_orient_2 = zeros (size(time));

cumul_effet_tti_total = zeros (size(time));
cumul_effet_tti_1 = zeros (size(time));
cumul_effet_tti_2 = zeros (size(time));
cumul_effet_tti_tang_1 = zeros (size(time));
cumul_effet_tti_orient_1 = zeros (size(time));
cumul_effet_tti_tang_2 = zeros (size(time));
cumul_effet_tti_orient_2 = zeros (size(time));

for i=1:length(time)
    distance(i) = norm(center_1_flt(i,:)-center_2_flt(i,:));
end

index_dmin=instantCroisement;
[mpdmin,indicempdmin]=min(mpd(in_motion:index_dmin));
[mpdmax,indicempdmax]=max(mpd(indicempdmin+in_motion-1:index_dmin));
indicempdmax=indicempdmax+indicempdmin;
[mpdmax2,indicempdmax2]=max(mpd(in_motion:index_dmin));

effect_mpd=effect_mpd_1(in_motion:index_dmin)+effect_mpd_2(in_motion:index_dmin);
effect_inst=[effect_mpd',effect_mpd_1(in_motion:index_dmin)',effect_mpd_2(in_motion:index_dmin)',effect_mpd_tang_1(in_motion:index_dmin)',effect_mpd_tang_2(in_motion:index_dmin)',effect_mpd_orient_1(in_motion:index_dmin)',effect_mpd_orient_2(in_motion:index_dmin)'];



for i= in_motion+1:index_dmin
    cumul_effet_mpd_total(i) =  cumul_effet_mpd_total(i-1) + effect_mpd_1(i) + effect_mpd_2(i);
    cumul_effet_mpd_1(i) =  cumul_effet_mpd_1(i-1) + abs(effect_mpd_1(i));
    cumul_effet_mpd_2(i) =  cumul_effet_mpd_2(i-1) + abs(effect_mpd_2(i));
    cumul_effet_tti_total(i) =  cumul_effet_tti_total(i-1) + effect_tti_1(i) + effect_tti_2(i);
    cumul_effet_tti_1(i) =  cumul_effet_tti_1(i-1) + effect_tti_1(i);
    cumul_effet_tti_2(i) =  cumul_effet_tti_2(i-1) + effect_tti_2(i);
    cumul_effet_mpd_tang_1(i) = cumul_effet_mpd_tang_1(i-1) + effect_mpd_tang_1(i);
    cumul_effet_mpd_orient_1(i) = cumul_effet_mpd_orient_1(i-1) + effect_mpd_orient_1(i);
    cumul_effet_mpd_tang_2(i) = cumul_effet_mpd_tang_2(i-1) + effect_mpd_tang_2(i);
    cumul_effet_mpd_orient_2(i) = cumul_effet_mpd_orient_2(i-1) + effect_mpd_orient_2(i);
    cumul_effet_tti_tang_1(i) = cumul_effet_tti_tang_1(i-1) + effect_tti_tang_1(i);
    cumul_effet_tti_orient_1(i) = cumul_effet_tti_orient_1(i) + effect_tti_orient_1(i);
    cumul_effet_tti_tang_2(i) = cumul_effet_tti_tang_2(i-1) + effect_tti_tang_2(i);
    cumul_effet_tti_orient_2(i) = cumul_effet_tti_orient_2(i-1) + effect_tti_orient_2(i);
end
indiceMaxi=indicempdmax+in_motion-2;
cumulMax=cumul_effet_mpd_total(indiceMaxi);
cumul1Max=cumul_effet_mpd_1(indiceMaxi);
cumul2Max=cumul_effet_mpd_2(indiceMaxi);
tang_1Max=cumul_effet_mpd_tang_1(indiceMaxi);
orient_1Max=cumul_effet_mpd_orient_1(indiceMaxi);
tang_2Max=cumul_effet_mpd_tang_2(indiceMaxi);
orient_2Max=cumul_effet_mpd_orient_2(indiceMaxi);
tti_fenetre=tti(in_motion:index_dmin)';
mpd_fenetre=mpd(in_motion:index_dmin)';

resultat = [mpd(in_motion), mpd(index_dmin), cumul_effet_mpd_total(index_dmin), cumul_effet_mpd_1(index_dmin), cumul_effet_mpd_2(index_dmin),...
    cumul_effet_mpd_tang_1(index_dmin), cumul_effet_mpd_orient_1(index_dmin),cumul_effet_mpd_tang_2(index_dmin), cumul_effet_mpd_orient_2(index_dmin),mpdmax,indicempdmax,mpdmin,indicempdmin,mpdmax2,indicempdmax2,...
    cumulMax,cumul1Max,cumul2Max,tang_1Max,orient_1Max,tang_2Max,orient_2Max];

% % % % % % % % % % %  These are the informative plots
% % % % % % % % % % figure(40)
% % % % % % % % % % % subplot(2,2,1)
% % % % % % % % % % %subplot(3,1,1)
% % % % % % % % % % plot(milieuEpaules{1}(:,1),milieuEpaules{1}(:,2),'k')
% % % % % % % % % % hold on
% % % % % % % % % % plot(milieuEpaules{2}(:,1),milieuEpaules{2}(:,2),'--b')
% % % % % % % % % % axis square
% % % % % % % % % % plot(milieuEpaules{1}(1,1),milieuEpaules{1}(1,2),'^k')
% % % % % % % % % % plot(milieuEpaules{2}(1,1),milieuEpaules{2}(1,2),'^k')
% % % % % % % % % % % plot(milieuEpaules{1}(in_motion+1,1),milieuEpaules{1}(in_motion+1,2),'dk')
% % % % % % % % % % % plot(milieuEpaules{2}(in_motion+1,1),milieuEpaules{2}(in_motion+1,2),'dk')
% % % % % % % % % % plot(milieuEpaules{1}(index_dmin,1),milieuEpaules{1}(index_dmin,2),'*k')
% % % % % % % % % % plot(milieuEpaules{2}(index_dmin,1),milieuEpaules{2}(index_dmin,2),'*k')
% % % % % % % % % % text(milieuEpaules{1}(index_dmin,1)+1,milieuEpaules{1}(index_dmin,2),'* dmin')
% % % % % % % % % % hold off
% % % % % % % % % % xlabel('x-position (m)')
% % % % % % % % % % ylabel('y-position (m)')
% % % % % % % % % % %
% % % % % % % % % % % % plot(milieuEpaules{1}(in_motion+1:index_dmin,1),milieuEpaules{1}(in_motion+1:index_dmin,2),'LineWidth',3)
% % % % % % % % % % % % plot(milieuEpaules{2}(in_motion+1:index_dmin,1),milieuEpaules{2}(in_motion+1:index_dmin,2),':','LineWidth',3)
% % % % % % % % % % %
% % % % % % % % % % % hold off
% % % % % % % % % % %
% % % % % % % % % % figure(4)
% % % % % % % % % % %subplot(3,1,2)
% % % % % % % % % % % hold off;
% % % % % % % % % % plot (time(in_motion+1:index_dmin),mpd(in_motion+1:index_dmin),'black','LineWidth',3)
% % % % % % % % % % %plot (mpd,'black')
% % % % % % % % % % xlabel('Time (s)')
% % % % % % % % % % ylabel('MPD (m)')
% % % % % % % % % %
% % % % % % % % % %
% % % % % % % % % %
% % % % % % % % % % figure(400)
% % % % % % % % % % plot (cumul_effet_mpd_total(in_motion+1:index_dmin),'black','LineWidth',3)
% % % % % % % % % % hold on
% % % % % % % % % % plot (cumul_effet_mpd_tang_1(in_motion+1:index_dmin),'r','LineWidth',2)
% % % % % % % % % % plot (cumul_effet_mpd_orient_1(in_motion+1:index_dmin),':r','LineWidth',2)
% % % % % % % % % % plot (cumul_effet_mpd_tang_2(in_motion+1:index_dmin),'b','LineWidth',2)
% % % % % % % % % % plot (cumul_effet_mpd_orient_2(in_motion+1:index_dmin),':','LineWidth',2)
% % % % % % % % % % hold off
% % % % % % % % % % legend('Total effect','Effect v1','Effect orientation1','Effect v2','Effect or2')
