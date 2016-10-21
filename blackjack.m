% Blackjack by Lachlan Page 
% Introduction To Programming MATLAB Assignment April 2016 
% =========
% BLACKJACK
% ========= 
%
% Features:
% GUI 
% Betting 
% BlackJack Pays 3 - 1 
% 



function main

    %Variables Needed At StartUp 
    global card_suit
    global hole_card
    global chips
    global bet 

    %SET NUMBER OF BETTING CHIPS; 
    chips = 1000; 
    bet = 0; 

    %Hide The Hole Card 
    hole_card = 0; 

    %Set Up Figure and Centre 
    surface = figure('Visible', 'off','color','white','Position',[300, 400, 800,800]);
    movegui(surface,'center')

    %HashTable Of Values 
    keyset = [1, 2 , 3, 4];
    valueset = {'Clubs', 'Diamonds', 'Hearts', 'Spades'};
    card_suit = containers.Map(keyset, valueset);
    
    
    %Start BlackJack 
    start();

    

    % GUI is made visible and Axes are centred and turned off 

    axis = axes('units','normalized', 'position',[0 0 1 1]);
    uistack(axis,'bottom');

    %Setbackground image to felt texture
    bgimage= imread('images/background.jpg');
    imagesc(bgimage);
    set(axis,'handlevisibility','off', 'visible','off')
    set(surface,'Visible','on')
end
 
%Functions To Handle Betting Increments 

function bet5(Object, eventdata)
    global bet

    bet = bet + 5; 
    bet_update(); 
end

function bet10(Object, eventdata)
    global bet

    bet = bet + 10; 
    bet_update(); 
end

function bet25(Object, eventdata)
    global bet

    bet = bet + 25; 
    bet_update(); 
end

function bet50(Object, eventdata)
    global bet
    bet = bet + 50; 
    bet_update(); 
end

function bet100(Object, eventdata)
    global bet 
    bet = bet + 100;
    bet_update();  
end

function clearbet(Object, eventdata)
    global bet 
    bet = 0; 
    bet_update();
end



function callbackDeal(Object, eventdata)
    %Function called when DEAL Button Is Pressed 

    global players_cards
    global dealers_cards 
    global chips
    global bet
    global betting_elements
    global hand 

    hand = 1;

    if (bet ~= 0)
        
       chips = chips - bet; 

       [players_cards] = get_cards(players_cards, 2);
       [dealers_cards] = get_cards(dealers_cards, 2);
       
       
    %Clear Betting Element UI 
       delete(betting_elements); 

       update(); 

    else

    end
end



function callbackhit(Object,eventdata)

     %Function Called When HIT Button Is Pressed 
     
     global players_cards
     global player_total
     global elements
     global hand 

     [players_cards] = get_cards(players_cards, 1);
     player_total = sum(players_cards(1,:));
     
     hand = 2; 
  
     update();
     
    %If players card total is greater than 21, player bust. 
     if (player_total > 21)
         
         elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [225,450, 350, 40], 'String', 'PLAYER BUST')];
         pause(2);

         new_hand();
     end
         
     
end

function callbackstand(Oject,eventdata)
    %Function Called When STAND Button pressed 

    global dealers_cards 
    global players_cards
    global chips 
    global bet
    global elements 
    global hole_card
    global hand
    
    %Dealers Hold Card Is Now Visible
    hole_card = 1; 
    
    hand = 0;
    
    
    dealers_total = sum(dealers_cards(1,:));
    players_total = sum(players_cards(1,:));
    
    
    %Dealer stands on hard 17. 
    while dealers_total < 17
        [dealers_cards] = get_cards(dealers_cards, 1);
        dealers_total = sum(dealers_cards(1,:));
        
        if (dealers_total > 17)
         for i = 1:length(dealers_cards)
             if(dealers_cards(i) == 11)
                 dealers_cards(i) = 1;
             end
         end
        end

    end
    
    update();
    pause(1); 
    
    
    %If Dealers Total Is Greater Than 21, dealer bust 
    if dealers_total > 21 

        elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [225,450, 350, 40], 'String', 'DEALER BUSTS')];
        chips = chips + 2*(bet);

        pause(2); 
        new_hand();
        
    %If Dealers Total is Greater Than Players, dealer wins. 
             
    elseif dealers_total > players_total
        elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [225,450, 350, 40], 'String', 'DEALER WINS')];
        
        pause(2);
        
        new_hand();
        
    elseif ((players_total == 21) && (length(players_cards) == 2))
        chips = chips + (3*bet); 
        elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [225,450, 350, 40], 'String', 'PLAYER BLACKJACK')];
        pause(2);
        
        new_hand();
        
    
    elseif dealers_total < players_total
        chips = chips + (2*bet);
        elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [225,450, 350, 40], 'String', 'PLAYER WINS')];
        pause(2);
        
        new_hand();
        
    elseif dealers_total == players_total
        chips = chips + bet;
        elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [225,450, 350, 40], 'String', 'PUSH')];
        pause(2);
        
        new_hand();
        
    end 

end

function [cards] = get_cards(card_set,num)

    %Num determines number of cards to be drawn 


    cards = []; 
    suits = [];

    % Retrieve the cards
    %Clubs = 1 
    %Diamond = 2, Hearts = 3, Spades = 4
    %EXAMPLE
    %       
    % Card Value   10   11
    % Suit         3    1
    %10 of hearts and Ace of Clubs

    card_values = [2 3 4 5 6 7 8 9 10 10 10 10 11];
    %card_suits = {'Spades', 'Hearts', 'Diamond', 'Clubs'};
    card_suits = [1 2 3 4];
    
    

    if num == 1
        card_one = card_values(randi(length(card_values)));
        suit_one = card_suits(randi(length(card_suits)));
        cards = [cards card_one;suit_one];
        cards = [card_set cards];


    elseif num == 2

        card_one = card_values(randi(length(card_values)));
        card_two = card_values(randi(length(card_values)));
        cards = [cards card_one card_two];
        suit_one = card_suits(randi(length(card_suits)));
        suit_two = card_suits(randi(length(card_suits)));
        suits = [suits suit_one suit_two];


        cards = [cards;suits]; 
    end


end


function new_hand() 

    global hole_card
    global bet 
    global hand 


    global elements
    
    %Clear All Elements 

    delete(elements);

    hole_card = 0;

    hand = 0; 

    pause(1)

    bet = 0; 

    start(); 

end

function bet_update()
    global bet 
    global betting_elements
    global chips 

    if (bet >= chips) 

        bet = chips; 
    end

    betting_elements = [betting_elements uicontrol('Style','text','Fontsize', 40,'Position', [10,600, 150, 50], 'String',bet)];
    betting_elements = [betting_elements uicontrol('Style','text','Fontsize', 20,'Position', [10, 650, 150, 30], 'String','Current Bet:')];

end



function update()

    global players_cards
    global dealers_cards
    global player_total 
    global dealer_total 
    global elements
    global chips
    global hole_card
    global bet
    global hand 
    global player_card_images
    global dealer_card_images

    elements = [elements uicontrol('Style','pushbutton','String','HIT', 'Position',[200,50,150,50],'Callback',@callbackhit)];
    elements = [elements uicontrol('Style','pushbutton','String','STAND', 'Position',[450,50,150,50],'Callback',@callbackstand)];



    player_total = sum(players_cards(1,:));

    dealer_total = sum(dealers_cards(1,:));

    if (hand == 1)

        for i=1:length(players_cards)
            player_card_images{i} = card_image(players_cards(1,i),players_cards(2,i));

        end

        for i=1:length(dealers_cards)
            dealer_card_images{i} = card_image(dealers_cards(1,i),dealers_cards(2,i));

        end

    end

    if (hand == 2)

        player_card_images{length(players_cards)} = card_image(players_cards(1,end),players_cards(2,end));

    end

    if(hand == 0)

        dealer_card_images{length(dealers_cards)} = card_image(dealers_cards(1,end), dealers_cards(2,end));
    end

     if (player_total > 21)
         for i = 1:length(players_cards)
             if(players_cards(i) == 11)
                 players_cards(i) = 1;
             end
         end
     end

    if (dealer_total > 17)
         for i = 1:length(dealers_cards)
             if(dealers_cards(i) == 11)
                 dealers_cards(i) = 1;
             end
         end
    end

    player_total = sum(players_cards(1,:));

    dealer_total = sum(dealers_cards(1,:));


    elements = [elements uicontrol('Style','text','Fontsize', 40,'Position', [10,700, 150, 50], 'String',chips)];
    elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [10,750, 150, 30], 'String','Chips Left:')];


    elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [600,400, 100, 40], 'String',player_total)];

    elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [600,450, 100, 40], 'String', 'TOTAL')];
    elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [100,450, 100, 40], 'String', 'TOTAL')];
    elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [100,400, 100, 40], 'String','')];

    elements = [elements uicontrol('Style','text','Fontsize', 40,'Position', [10,600, 150, 50], 'String',bet)];
    elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [10, 650, 150, 30], 'String','Current Bet:')];


    for i = 1:length(players_cards)

        elements = [elements uicontrol('Style', 'pushbutton', 'Position', [200+(i*100), 150, 150, 218],  'cdata', imread(player_card_images{i}))];


    end
    
    if (hole_card == 0) 
        hole = imread('images/back.png');
         
        
        for i = 1:length(dealers_cards)
            if(i == 2)
                 
                elements = [elements uicontrol('Style', 'pushbutton', 'Position', [200+(i*100), 550, 150, 218],  'cdata', hole)];
            
            else
                
       
                elements = [elements uicontrol('Style', 'pushbutton', 'Position', [200+(i*100), 550, 150, 218],  'cdata', imread(dealer_card_images{i}))];
        
            end
            
            if(sum(dealers_cards) == 21)
                
                elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [225,450, 350, 40], 'String', 'DEALER BLACKJACK')];
            end
        end
        
     
    
    end
    
    if (hole_card == 1) 
        
        for i = 1:length(dealers_cards)
       
            elements = [elements uicontrol('Style', 'pushbutton', 'Position', [200+(i*100), 550, 150, 218],  'cdata', imread(dealer_card_images{i}))];
            elements = [elements uicontrol('Style','text','Fontsize', 20,'Position', [100,400, 100, 40], 'String',dealer_total)];    
        
        end
        
    end
        
   
    end
        

function start()

    global chips 
    global bet
    global betting_elements

    logo = imread('images/blackjack_logo.png');
    
    %Betting UI Elements 

    betting_elements = [betting_elements uicontrol('Style','text','Fontsize', 20,'Position', [240,120, 320, 400], 'String','')];
    betting_elements = [betting_elements uicontrol('Style','text','Fontsize', 40,'Position', [10,700, 150, 50], 'String',chips)];
    betting_elements = [betting_elements uicontrol('Style','text','Fontsize', 20,'Position', [10,750, 150, 30], 'String','Chips Left:')];
    betting_elements = [betting_elements uicontrol('Style','pushbutton','String','DEAL', 'Fontsize', 20,'Position',[250,400,300,100],'Callback',@callbackDeal)];
    betting_elements = [betting_elements uicontrol('Style','text','Fontsize', 20,'Position', [250,370, 300, 30], 'String','Place Your Bets:')];
    betting_elements = [betting_elements uicontrol('Style','pushbutton','String','5', 'Fontsize', 20,'Position',[300,320,90,50],'Callback',@bet5)];
    betting_elements = [betting_elements uicontrol('Style','pushbutton','String','10','Fontsize', 20, 'Position',[400,320,90,50],'Callback',@bet10)];
    betting_elements = [betting_elements uicontrol('Style','pushbutton','String','25','Fontsize', 20, 'Position',[300,260,90,50],'Callback',@bet25)];
    betting_elements = [betting_elements uicontrol('Style','pushbutton','String','50', 'Fontsize', 20,'Position',[400,260,90,50],'Callback',@bet50)];
    betting_elements = [betting_elements uicontrol('Style','pushbutton','String','100','Fontsize', 20, 'Position',[300,200,190,50],'Callback',@bet100)];
    betting_elements = [betting_elements uicontrol('Style','pushbutton','String','CLEAR BETS', 'Fontsize', 20,'Position',[300,140,190,50],'Callback',@clearbet)];
    betting_elements = [betting_elements uicontrol('Style','text','Fontsize', 40,'Position', [10,600, 150, 50], 'String',bet)];
    betting_elements = [betting_elements uicontrol('Style','text','Fontsize', 20,'Position', [10, 650, 150, 30], 'String','Current Bet:')];
    betting_elements = [betting_elements uicontrol('Style','pushbutton','String','CLEAR BETS', 'Position',[180,600,600,180],'cdata',logo, 'BackgroundColor',[0 0 0])];


end

function [filepath] = card_image(card, suit)
    %Card Image FilePath Retrieval 
    
    prefix = '';  
    card = num2str(card);
    if suit == 1
        suit = 'c';
    elseif suit ==2
        suit = 'd';
    elseif suit ==3
        suit = 'h';
    elseif suit ==4
        suit = 's';
    end

    if strcmp(card,'1') 
        card = '11'; 
    end

    if strcmp(card,'10')
        num = randi(4);
        if num == 1
            prefix = '1'; 
        elseif num == 2
            prefix = '2';
        elseif num ==3 
            prefix = '3'; 
        elseif num ==4
            prefix = '4'; 
        end
    end

    filepath = strcat('images/',card);
    filepath = strcat(filepath, suit);
    filepath = strcat(filepath, prefix); 
    filepath = strcat(filepath, '.png');
    
end





