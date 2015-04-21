function Graph = GraphLoadSample(SampleName,varargin)
% Returns sample graph
%
% Receives:
%   SampleName - string - case-insensitive name of the sample to load. See the table below.
%
% Returns:
%   Graph - struct - struct compatible with GraphLoad
%
%
% See Also:
%   GraphLayoutAddFrame, GraphLayoutInitialize
%
% %
%           Erdosh-Renei or Poission graph mexGraphGeneratePoissonRandomGraph
%        Sample Type :  'poisson', 'ER', 'Erdosh-Renei' 
%        N           -    number of nodes. 
%        p           -    probability of tie
% 
%         example: 
%             Graph = GraphLoadSample('Poisson','N',200,'p',0.025);
% 
%         Power law
%         Sample Type :  'power law', 'PL' 
%        N           -    number of nodes. 
%        Gamma       -    power law Gamma 
%             Graph = GraphLoadSample('Power Law','N',200,'Gamma',2.2);
% 
%         Small World : "small world', 'watts&strogatz'. GraphCreateSmallWorld
%             N           -    number of nodes. 
%             K  - degree of each node. Must be even
%             beta        -    probability to rewire            
%         Graph = GraphLoadSample('Small World','N',20,'K',4,'pbeta',0.1);
% 
% 
% % SAMPLE DATA:
%         Les Miserables  - coappearance weighted network of characters in the novel Les Miserables. D. E. Knuth, The Stanford GraphBase: A Platform for Combinatorial Computing, Addison-Wesley, Reading, MA (1993). http://wiki.gephi.org/index.php/Datasets
%         Karate, Karate Club - Zachary's karate club: social network of friendships between 34 members of a karate club at a US university in the 1970s. W. W. Zachary, An information flow model for conflict and fission in small groups, Journal of Anthropological Research 33, 452-473 (1977).  http://wiki.gephi.org/index.php/Datasets
%         Coauthorships - Coauthorships in network science: coauthorship network of scientists working on network theory and experiment, as compiled by M. Newman in May 2006. A figure depicting the largest component of this network can be found here. M. E. J. Newman, Phys. Rev. E 74, 036104 (2006). http://wiki.gephi.org/index.php/Datasets
%         Internet - Internet: a symmetrized snapshot of the structure of the Internet at the level of autonomous systems, reconstructed from BGP tables posted by the University of Oregon Route Views Project. This snapshot was created by Mark Newman from data for July 22, 2006 and is not previously published. http://wiki.gephi.org/index.php/Datasets
%         Power Grid - Power grid: An undirected, unweighted network representing the topology of the Western States Power Grid of the United States. Data compiled by D. Watts and S. Strogatz and made available on the web here. Please cite D. J. Watts and S. H. Strogatz, Nature 393, 440-442 (1998). http://wiki.gephi.org/index.php/Datasets
%         Word adjacencies -  Word adjacencies: adjacency network of common adjectives and nouns in the novel David Copperfield by Charles Dickens. Please cite M. E. J. Newman, Phys. Rev. E 74, 036104 (2006). http://wiki.gephi.org/index.php/Datasets
%         Football - American College football: network of American football games between Division IA colleges during regular season Fall 2000. Please cite M. Girvan and M. E. J. Newman, Proc. Natl. Acad. Sci. USA 99, 7821-7826 (2002). http://www-personal.umich.edu/~mejn/netdata/
%         Dolphins -  social network: an undirected social network of frequent associations between 62 dolphins in a community living off Doubtful Sound, New Zealand. Please cite D. Lusseau, K. Schneider, O. J. Boisseau, P. Haase, E. Slooten, and S. M. Dawson, Behavioral Ecology and Sociobiology 54, 396-405 (2003). Thanks to David Lusseau for permission to post these data on this web site. http://www-personal.umich.edu/~mejn/netdata/
%         Political blogs - Political blogs: A directed network of hyperlinks between weblogs on US politics, recorded in 2005 by Adamic and Glance. Please cite L. A. Adamic and N. Glance, "The political blogosphere and the 2004 US Election", in Proceedings of the WWW-2005 Workshop on the Weblogging Ecosystem (2005). Thanks to Lada Adamic for permission to post these data on this web site. http://www-personal.umich.edu/~mejn/netdata/
%         Books - Books about US politics: A network of books about US politics published around the time of the 2004 presidential election and sold by the online bookseller Amazon.com. Edges between books represent frequent copurchasing of books by the same buyers. The network was compiled by V. Krebs and is unpublished, but can found on Krebs' web site. Thanks to Valdis Krebs for permission to post these data on this web site. http://www-personal.umich.edu/~mejn/netdata/
%         Neural network - Neural network: A directed, weighted network representing the neural network of C. Elegans. Data compiled by D. Watts and S. Strogatz and made available on the web here. Please cite D. J. Watts and S. H. Strogatz, Nature 393, 440-442 (1998). Original experimental data taken from J. G. White, E. Southgate, J. N. Thompson, and S. Brenner, Phil. Trans. R. Soc. London 314, 1-340 (1986).http://www-personal.umich.edu/~mejn/netdata/
%         CondMat1999 - Condensed matter collaborations 1999: weighted network of coauthorships between scientists posting preprints on the Condensed Matter E-Print Archive between Jan 1, 1995 and December 31, 1999. Please cite M. E. J. Newman, The structure of scientific collaboration networks, Proc. Natl. Acad. Sci. USA 98, 404-409 (2001).http://www-personal.umich.edu/~mejn/netdata/
%         CondMat2003 - Condensed matter collaborations 2003: updated network of coauthorships between scientists posting preprints on the Condensed Matter E-Print Archive. This version includes all preprints posted between Jan 1, 1995 and June 30, 2003. The largest component of this network, which contains 27519 scientists, has been used by several authors as a test-bed for community-finding algorithms for large networks; see for example J. Duch and A. Arenas, Phys. Rev. E 72, 027104 (2005). These data can be cited as M. E. J. Newman, Proc. Natl. Acad. Sci. USA 98, 404-409 (2001). http://www-personal.umich.edu/~mejn/netdata/
%         CondMat2005 - Condensed matter collaborations 2005: updated network of coauthorships between scientists posting preprints on the Condensed Matter E-Print Archive. This version includes all preprints posted between Jan 1, 1995 and March 31, 2005. Please cite M. E. J. Newman, Proc. Natl. Acad. Sci. USA 98, 404-409 (2001).http://www-personal.umich.edu/~mejn/netdata/
%         Astrophysics - Astrophysics collaborations: weighted network of coauthorships between scientists posting preprints on the Astrophysics E-Print Archive between Jan 1, 1995 and December 31, 1999. Please cite M. E. J. Newman, Proc. Natl. Acad. Sci. USA 98, 404-409 (2001).
%         hightenergyphys - High-energy theory collaborations: weighted network of coauthorships between scientists posting preprints on the High-Energy Theory E-Print Archive between Jan 1, 1995 and December 31, 1999. Please cite M. E. J. Newman, Proc. Natl. Acad. Sci. USA 98, 404-409 (2001). http://www-personal.umich.edu/~mejn/netdata/
% 
% 
%         Graph = GraphLoadSample('Les Miserables');
%         Graph = GraphLoadSample('Karate Club');
%         Graph = GraphLoadSample('Coauthorships');
%         Graph = GraphLoadSample('Internet');
%         Graph = GraphLoadSample('Power Grid');
%         Graph = GraphLoadSample('Word Adjacencies');
% 
%         Graph = GraphLoadSample('Football');
%         Graph = GraphLoadSample('Dolphins');
%         Graph = GraphLoadSample('Political blogs');
% 
%         Graph = GraphLoadSample('Books');
%         Graph = GraphLoadSample('Neural network');
% 
%         Graph = GraphLoadSample('CondMat1999');
%         Graph = GraphLoadSample('CondMat2003');
%         Graph = GraphLoadSample('CondMat2005');
%         Graph = GraphLoadSample('Astrophysics');
%         Graph = GraphLoadSample('hightenergyphys');
% 

%

narginchk(1,inf);
nargoutchk(0,1);

if ~FIOProcessInputParameters(GetDefaultInput)
    error('The default input is not FlexIO compatible');
end
if ~FIOProcessInputParameters(varargin)
    error('The input is not FlexIO compatible');
end

switch lower(SampleName)
    case 'poisson'
        Graph = GetPoissonGraph(N,p);
    case 'er'
        Graph = GetPoissonGraph(N,p);
    case 'erdosh-renei'
        Graph = GetPoissonGraph(N,p);
    case 'power law'
        Graph= GetPowerLawGraph(N,Gamma);
    case 'pl'
        Graph= GetPowerLawGraph(N,Gamma);
    case 'small world'
        Graph= GraphCreateSmallWorld(N,K,pbeta);
    case 'watts&strogatz'
        Graph= GraphCreateSmallWorld(N,K,pbeta);
    case 'les miserables'
        Graph = GraphLoadGML([GetSampleFolderName() 'lesmiserables.gml']); 
    case 'karate'
        Graph = GraphLoadGML([GetSampleFolderName() 'karate.gml']); 
    case 'karate club'
        Graph = GraphLoadGML([GetSampleFolderName() 'karate.gml']); 
    case 'coauthorships'
        Graph = GraphLoadGML([GetSampleFolderName() 'netscience.gml']); 
    case 'internet'
        Graph = GraphLoadGML([GetSampleFolderName() 'internet_routers-22july06.gml']); 
    case 'power grid'
        Graph = GraphLoadGML([GetSampleFolderName() 'power.gml']);     
    case 'word adjacencies'
        Graph = GraphLoadGML([GetSampleFolderName() 'word_adjacencies.gml']); 
    case 'football'
        Graph = GraphLoadGML([GetSampleFolderName() 'football.gml']);         
    case 'dolphins'
        Graph = GraphLoadGML([GetSampleFolderName() 'dolphins.gml']);       
    case 'political blogs'
        Graph = GraphLoadGML([GetSampleFolderName() 'polblogs.gml']);        
    case 'books'
        Graph = GraphLoadGML([GetSampleFolderName() 'polbooks.gml']);        
    case 'neural network'
        Graph = GraphLoadGML([GetSampleFolderName() 'celegansneural.gml']);       
    case 'condmat1999'
        Graph = GraphLoadGML([GetSampleFolderName() 'cond-mat.gml']);       
    case 'condmat2003'
        Graph = GraphLoadGML([GetSampleFolderName() 'cond-mat-2003.gml']);    
    case 'condmat2005'
        Graph = GraphLoadGML([GetSampleFolderName() 'cond-mat-2005.gml']);    
    case 'astrophysics'
        Graph = GraphLoadGML([GetSampleFolderName() 'astro-ph.gml']);   
    case 'hightenergyphys'
        Graph = GraphLoadGML([GetSampleFolderName() 'hep-th.gml']);    
           
    otherwise
        error('unsupported sample name: ''%s''',SampleName);
end
Graph.Signature{end+1} = mfilename;
Graph.About = SampleName;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Graph= GetPoissonGraph(N,p)
    Graph = mexGraphGeneratePoissonRandomGraph(N,p);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Graph= GetPowerLawGraph(N,Gamma)
    %define node degree distribution:
    XAxis  = unique(round(logspace(0,log10(N),25)));
    YAxis  = unique(round(logspace(0,log10(N),25))).^(-Gamma+1);
    % create the graph with the required node degree distribution:
    Graph = mexGraphCreateRandomGraph(N,XAxis,YAxis,1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FolderName = GetSampleFolderName()
 FolderName= [fileparts(mfilename('fullpath')) '\NetworkLibrary\'];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DefaultInput  = GetDefaultInput()
DefaultInput = {};
end % GetDefaultInput()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
