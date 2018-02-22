#!/.../wlst.sh

servers = ['s1', 's2']

def listJMSclients():
    serverRuntime()
    relpath = '/JMSRuntime'
    cd(relpath)
    jmsruntime = cmo.getJMSRuntime()
    jmsRname = jmsruntime.getName()
    cd(relpath+'/'+jmsRname+'/'+'JMSServers/')
    jmsservers = cmo.getJMSServers()
    for jmsserver in jmsservers:
        jmsserverName = jmsserver.getName()
        cd(relpath+'/'+jmsRname+'/'+'JMSServers/'+jmsserverName+'/Destinations')
        dests = cmo.getDestinations()
        for dest in dests:
            destName = dest.getName()
            destType = dest.getDestinationType()
            cd(relpath+'/'+jmsRname+'/'+'JMSServers/' +
               jmsserverName+'/Destinations/'+destName)
            if destType == 'Topic':
                cd(relpath+'/'+jmsRname+'/'+'JMSServers/'+jmsserverName +
                   '/Destinations/'+destName+'/DurableSubscribers/')
                dslist = cmo.getDurableSubscribers()
                for ds in dslist:
                    subname = ds.getName()
                    cd(relpath+'/'+jmsRname+'/'+'JMSServers/'+jmsserverName +
                       '/Destinations/'+destName+'/DurableSubscribers/'+subname)
                    CClient = subname[:subname.find('@')]
                    if cmo.isActive() == 1:
                        print 'Active: true '+CClient+' '+destName
                    elif cmo.isActive() == 0:
                        print 'Active: false '+CClient+' '+destName
                    else:
                        print 'ERROR: subscriber '+subname+' isActive property neither false nor true'

for ctr in range(0, len(servers)):
    connect(userConfigFile='path to secured admin conf',
            userKeyFile='path to secured admin key', url='t3://'+servers[ctr]+':<port>')
    listJMSclients()
    disconnect()
