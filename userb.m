prompt= 'user B enter your FIVE DIGIT PRIME  password ';
TextB           = input(prompt);
MessageB         = int32(TextB);
fprintf('-Input-\n')
fprintf('Original message:       ''%s''\n', TextB)
fprintf('Integer representation: %s\n', num2str(MessageB))
%% Generate Key Pair
[Modulus, PublicExponent, PrivateExponent] = GenerateKeyPair;
fprintf('\n-Key Pair-\n')
fprintf('Modulus:                '), fprintf('%5d\n', Modulus)
fprintf('Public Exponent:        '), fprintf('%5d\n', PublicExponent)
fprintf('Private Exponent:       '), fprintf('%5d\n', PrivateExponent)
%% Encrypt / Decrypt
Ciphertext      = Encrypt(Modulus, PublicExponent, MessageB)

c1=Ciphertext(1,1)
c2=Ciphertext(1,2)
c3=Ciphertext(1,3)
c4=Ciphertext(1,4)
c5=Ciphertext(1,5)


sti=fopen('passwordciphertextb.txt','w')
fprintf(sti,'%d %d %d %d %d',c1,c2,c3,c4,c5);
fclose(sti);
"sent ciphertext to A"

prompt= 'request lowest unique value'

status         = input(prompt);

sti=fopen('lowestuniqueb.txt','r')
luv=fscanf(sti,'%li')
fclose(sti)




pass        = 10007;

key1= mod(luv,pass)
prompt= 'is the ciphertext received'

status1         = input(prompt);

sti=fopen('ciphertextb.txt','r')
cipher_of_message =fscanf(sti,'%li')
fclose(sti)



message_from_A = bitxor(cipher_of_message,key1)
disp (message_from_A)
"successfully recieved"

%functions start

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
   % p = int32(randseed(randseed, 1, 1, 10, 100));
   % q = int32(randseed(randseed, 1, 1, 10, 100));
   p = 101;
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
