func words(xs: Array<Int64>): CPointer<Int64> {
 let p=unsafe{CPointer<Int64>(calloc(UIntNative(xs.size+1),UIntNative(8)))}
 for(i in 0..xs.size){unsafe{(p+i).write(xs[i])}};p
}
func authBench(name:String,n:Int64,expected:Int64,work:()->Int64): Unit {
 checked(work(),expected);checked(work(),expected)
 let reps=calibrate(work,1048576)
 for(t in 0..7){sample(name,"CJR",n,1,t,reps,expected,work)}
}
@Test
class AuthenticatorBenchmarks {
 @TestCase func representative(): Unit {
 let key=words([49,50,51,52,53,54,55,56,57,48,49,50,51,52,53,54,55,56,57,48])
 let msg=words([97,98,99]);let out=words(Array<Int64>(128,repeat:0))
 let secret=words([74,66,83,87,89,51,68,80,69,72,80,75,51,80,88,80])
 let label=words([97]);let issuer=words([98])
 authBench("sha_one",3,169,{=>if(!authSha1(msg,3,out)){throw Exception("SHA failure")};unsafe{out.read()}})
 authBench("hmac",3,177,{=>if(!authHmac(key,20,msg,3,out)){throw Exception("HMAC failure")};unsafe{out.read()}})
 authBench("hotp",20,755224,{=>authHotp(key,20,0,6)})
 authBench("totp",20,94287082,{=>authTotp(key,20,59,30,8)})
 authBench("base_decode",16,82,{=>let n=authBase32(secret,16,out);n+unsafe{out.read()}})
 authBench("session",1,3,{=>
    let session=authNew();let id=authAdd(session,label,1,issuer,1,secret,16,6,30)
    if(id<1){throw Exception("Enrollment failure")}
    let count=authList(session,out)
    if(!authRead(session,id,out)){throw Exception("Account read failure")}
    if(!authRename(session,id,label,1,issuer,1)){throw Exception("Rename failure")}
    if(!authRemove(session,id)){throw Exception("Removal failure")}
    authDestroy(session);id+count+1
 })
 unsafe{free(CPointer<Unit>(key));free(CPointer<Unit>(msg));free(CPointer<Unit>(out));free(CPointer<Unit>(secret));free(CPointer<Unit>(label));free(CPointer<Unit>(issuer))}
 }
}
