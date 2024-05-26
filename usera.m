prompt= 'enter the secret number you want to transmit to B ';
p1=input(prompt);
prompt= 'enter the secret number you want to transmit to C ';
p2=input(prompt);
pb1 = dec2bin(p1);
pb2 = dec2bin(p2);

len1=length(pb1);
len2=length(pb2);
ma=max(len1,len2);
if len1==ma
    pad=len1-len2;
    a=zeros(1,pad);
    pb2 = cat(2, a, pb2);
elseif len2==ma
    pad=len2-len1;
    a=zeros(1,pad);
    pb1 = cat(2, a, pb1)
end
k1 = randi([(2.^(ma-1)) (2.^ma)-1])
kb1 = dec2bin(k1);
c1 = bitxor(k1,p1);
k2 =  bitxor(c1,p2)
kb2 = dec2bin(k2);
c2= bitxor(k2,p2);
"the cipher to be transmitted is"

sti=fopen('ciphertext.txt','w')
 fprintf(sti,'%d',c2);
 fclose(sti);



disp(c1)

prompt= 'ask user b for rsa ciphertext ';
status1=input(prompt);

sti=fopen('passwordciphertextb.txt','r')
ciphertransposeb=fscanf(sti,'%d');
fclose(sti);
Modulus = 38683;
PublicExponent = 3;
PrivateExponent = 25467;


Ciphertext = ciphertransposeb'
RestoredMessage	= Decrypt(Modulus, PrivateExponent, Ciphertext);
fprintf('Restored Message:       ''%s''\n', char(RestoredMessage))
RestoredMessageb=char(RestoredMessage)


prompt= 'ask user c for rsa ciphertext ';
status2=input(prompt);

sti=fopen('passwordciphertextc.txt','r')
ciphertransposec=fscanf(sti,'%d');
fclose(sti);

Modulus = 38683;
PublicExponent = 3;
PrivateExponent = 25467;

Ciphertext = ciphertransposec'

RestoredMessage	= Decrypt(Modulus, PrivateExponent, Ciphertext);
fprintf('Restored Message:       ''%s''\n', char(RestoredMessage))
RestoredMessagec= char(RestoredMessage)




b1=str2num(RestoredMessageb);

b2=str2num(RestoredMessagec);


g1= k1;

g2= k2;

b =[b1,b2] % the bases should be relativly prime
g =[g1,g2] % the number represention (g) encryted in a unique way
% Objective: To find the smallest x such that: 
% a. g=mod(x,b) or written in another way
% b. x =(%b) g  
[bx by] = meshgrid(b, b);
bb = gcd(bx,by)-diag(b);
pp = ~sum(sum(bb>1)); 
if (pp)
    display(['The Bases [relativly prime] are: b=[' num2str(b) ']'])
    display(['The Number [representation] is : g=<' num2str(g) '>' ])
    
    % take out one by one bases and replace with 1's 
    xo = by-diag(b-1);
    
    % and get the product of the others
    Mk = prod(xo);
    
    % now we should get an solution for x and xa where Mk.*xa =(%b) x =(%b) 1
    % note that xa.*g is a solution, i.e xa.*g =(%b) g, because xa =(%b) ones
    [Gk, nk, Nk] = gcd ( b, Mk ) ;
    % [G,C,D] = GCD( A, B ) also returns C and D so that G = A.*C + B.*D.
    % These are useful for solving Diophantine equations and computing
    % Hermite transformations.
    
    % Then the strange step
    Sum_g_Nk_Mk = sum ( (g .* Nk) .* Mk ) ;
    
    % get the lowest period unique answer between [0:(product(b)-1)]
    x = mod(Sum_g_Nk_Mk,prod(b));
    x=(num2str(x,'%.0f'))
    
    display(['The Number [lowest unique value] is: x=''' num2str(x) '''' ])
else
    display('The Bases are NOT Relprime.')
end

"tramsmit the lowest unique value to B and C"

sti=fopen('lowestunique.txt','w')
 fprintf(sti,'%d',x);
 fclose(sti);



 "message successfully transmitted"
 function Message = Decrypt(Modulus, PrivateExponent, Ciphertext)
    Message = ModularExponentiation(Ciphertext, PrivateExponent, Modulus);
end
function Ciphertext = Encrypt(Modulus, PublicExponent, Message)
    Ciphertext = ModularExponentiation(Message, PublicExponent, Modulus);   
end
function [gcd, x, y] = ExtendedEuclideanAlgorithm(a, b)
    a = int32(a);
    b = int32(b);
    x = int32(0);
    y = int32(1);
    u = int32(1); 
    v = int32(0);
    
    while a ~= 0
        q = idivide(b, a);
        r = mod(b, a);
        m = x - u*q; 
        n = y - v*q;
        b = a;
        a = r;
        x = u;
        y = v;
        u = m;
        v = n;
    end
    
    gcd = b; 
   
end
function [Modulus, PublicExponent, PrivateExponent] = GenerateKeyPair
    % 1. Generate a pair of large, random primes p and q
    %p = int32(randseed(randseed, 1, 1, 10, 100));
    p = 101;
    %q = int32(randseed(randseed, 1, 1, 10, 100));
    q = 383;
    
    % 2. Compute the modulus n = pq
    n = p * q;
    
    % 3. Calculate Phi using Euler's totient function
    Phi         = (p - 1) * (q - 1);
    % 4. Find e that is relatively prime to Phi 
    e = NaN;
    
    for i = 3 : 2 : Phi - 1
        if gcd(i, Phi) == 1
            e = int32(i);
            break
        end
    end
    
    if isnan(e)
        error('No relative prime between p - 1 and q - 1 was found.')
    end
    
    % 5. Compute the private exponent d from e, p and q.
    [~, d, ~]   = ExtendedEuclideanAlgorithm(e, Phi);
    
    if d < 0
        d = Phi + d;
    end
    
    % 6. Output (n, e) as the public key and (n, d) as the private key
    Modulus         = n;
    PublicExponent  = e;
    PrivateExponent = d;
    
end
function Result = ModularExponentiation(Base, Exponent, Modulus)
    Result          = 1;
    TempExponent    = 0;
    
    while true
        
        TempExponent    = TempExponent + 1;        
        Result          = mod((Base .* Result), Modulus);
        
        if TempExponent == Exponent
            break
        end
        
    end
    
end







