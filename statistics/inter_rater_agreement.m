function iri = inter_rater_agreement(X)
%where X is a vector of data, iri is the average correlation between each
%coloum
R = corrcoef(X);
RPairs = [nchoosek(1:size(X,2),2), nonzeros(tril(R,-1))];
iri = mean(RPairs(:,3));